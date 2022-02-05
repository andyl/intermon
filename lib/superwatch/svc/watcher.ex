defmodule Superwatch.Svc.Watcher do

  use GenServer

  defstruct [:pid, :dirs, :ftypes, :filter, :tripwire]

  @debounce_timeout 250

  @proc_name :monitor_proc

  alias Superwatch.Svc.Watcher
  alias Superwatch.Svc.Worker

  @moduledoc """
  Watcher - file watcher and command runner

  Struct:
  - pid         - the watcher pid
  - dirs        - the file-monitor directories
  - filetypes   - type of file monitored (eg ex,exs)
  - filter      - filename patterns
  - tripwire    - used by the debounce algorithm

  Workflow:
  - start the file watcher
  - on file-change event, a debounce timer is started
  - when the timer quits, the worker is started

  Background:
  - the file watcher can emit many events upon file save
  - to avoid multiple worker starts, a debounce technique is used
  - the debounce timeout is `@debounce_timeout` milliseconds
  """

  # ----- startup / shutdown

  def start_link, do: start_link([])

  def start_link(opts) when is_list(opts) do
    state = opts |> set_state()
    GenServer.start_link(__MODULE__, state, name: @proc_name)
  end

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  # ----- api

  def api_start, do: api_start([])

  def api_start(opts) when is_list(opts) do
    GenServer.call(@proc_name, {:start, opts})
  end

  def api_stop do
    GenServer.call(@proc_name, :stop)
  end

  def api_state do
    GenServer.call(@proc_name, :state)
  end

  def api_set(opts) when is_list(opts) do
    GenServer.call(@proc_name, {:set, opts})
  end

  def api_running? do
    GenServer.call(@proc_name, :pid)
  end

  def api_pid do
    GenServer.call(@proc_name, :pid)
  end

  def api_pidinfo do
    GenServer.call(@proc_name, :pidinfo)
  end

  # ----- callbacks


  @impl true
  def handle_info({:file_event, _monitor_pid, {path, _events}}, state) do

    if target_path?(path, state) && ! state.tripwire do
      Process.send_after(self(), :tripwire_exec, @debounce_timeout)
    end

    {:noreply, %{state | tripwire: true}}
  end

  @impl true
  def handle_info(:tripwire_exec, state) do
    Worker.api_start()
    {:noreply, %{state | tripwire: nil}}
  end

  @impl true
  def handle_call({:start, opts}, _from, state) do
    optsmap = opts |> to_map()
    if state.pid, do: stop_mon(state.pid)
    new_state = state |> Map.merge(optsmap)
    new_pid = new_state |> start_mon()
    {:reply, new_pid, %Watcher{new_state | pid: new_pid}}
  end

  @impl true
  def handle_call(:stop, _from, state) do
    if state.pid, do: stop_mon(state.pid)
    {:reply, :ok, %Watcher{state | pid: nil}}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:set, opts}, _from, state) do
    optsmap = opts |> to_map()
    new_state = Map.merge(state, optsmap)
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call(:pid, _from, state) do
    {:reply, state.pid, state}
  end

  @impl true
  def handle_call(:pidinfo, _from, state) do
    info = Process.info(state.pid)
    {:reply, info, state}
  end

  # ----- helpers

  def start_mon(opts) do
    startmon = fn ->
      dirs = opts.dirs
             |> Enum.map(fn(x) -> Path.expand(x) end)
             |> Enum.filter(fn(x) -> File.exists?(x) end)
      {:ok, pid} = FileSystem.start_link(dirs: dirs)
      FileSystem.subscribe(pid)
      pid
    end
    case opts.dirs do
      nil -> nil
      [] -> nil
      _ -> startmon.()
    end
  end

  def stop_mon(nil), do: :ok

  def stop_mon(pid) do
    Process.exit(pid, :normal)
  end

  defp set_state(opts) when is_map(opts) do
    %Watcher{
      pid:      Map.get(opts, :pid, nil),
      dirs:     Map.get(opts, :dirs, ~w(lib test apps)),
      ftypes:   Map.get(opts, :ftypes, ~w(ex eex heex exs)),
      filter:   Map.get(opts, :filter, nil),
      tripwire: Map.get(opts, :tripwire, nil),
    }
  end


  defp set_state(opts) when is_list(opts) do
    %Watcher{
      pid:      Keyword.get(opts, :pid, nil),
      dirs:     Keyword.get(opts, :dirs, ~w(lib test)),
      ftypes:   Keyword.get(opts, :ftypes, ~w(ex eex heex exs)),
      filter:   Keyword.get(opts, :filter, nil),
      tripwire: Keyword.get(opts, :tripwire, nil),
    }
  end

  defp target_path?(path, state) do
    filter = case state.filter do
      nil -> true
      [] -> true
      list -> Enum.any?(list, fn (item) -> path =~ item end)
    end
    ftype = case state.ftypes do
      nil -> true
      [] -> true
      list -> Enum.any?(list, fn (item) -> path =~ item end)
    end
    filter && ftype
  end

  defp to_map(opts) when is_list(opts) do
    opts |> Enum.into(%{})
  end

  defp to_map(opts) when is_map(opts) do
    opts
  end
end
