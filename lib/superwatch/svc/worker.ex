defmodule Superwatch.Svc.Worker do

  use GenServer

  defstruct [:task, :cmd, :prompt, :clearscreen]

  @proc_name :worker_proc

  alias Superwatch.Svc.Worker

  @moduledoc """
  Worker - a command runner

  The worker command is typically a test program like:
  - `rspec` (ruby)
  - `mix test` (elixir)

  The command could also be a compiler, linter, etc.

  This command is started over and over by a file-system Watcher.  When a file
  changes, the Worker is auto-started by the Watcher.

  Struct:
  - task   - the PID of an active worker process
  - cmd    - the command to be run
  - prompt - the CLI prompt to render after the task is complete
  - clearscreen - boolean option to clear the screen between each run
  """

  # ----- startup / shutdown

  def start_link, do: start_link([])

  def start_link(cmd) when is_binary(cmd) do
    start_link([cmd: cmd])
  end

  def start_link(opts) when is_list(opts) do
    state = opts |> set_state()
    GenServer.start_link(__MODULE__, state, name: @proc_name)
  end

  @impl true
  def init(opts) do
    task = case opts.cmd do
      nil -> nil
      ""  -> nil
      cmd -> start_cmd(cmd)
    end
    new_opts = %{opts | task: task}
    {:ok, set_state(new_opts)}
  end

  # ----- api

  @doc """
  Start the worker command.

  Uses the internal state to know what command to launch.

  Can be passed an option set to update the state before launching the command.
  """
  def api_start, do: api_start([])

  def api_start(cmd) when is_binary(cmd) do
    api_start([cmd: cmd])
  end

  def api_start(opts) when is_list(opts) do
    GenServer.call(@proc_name, {:start, opts})
  end

  @doc """
  Stop the worker command.

  Stops a running worker command.
  """
  def api_stop do
    GenServer.call(@proc_name, :stop)
  end

  def api_kill do
    GenServer.call(@proc_name, :kill)
  end


  @doc """
  Exit the Worker process.
  """
  def api_exit do
    GenServer.cast(@proc_name, :exit)
  end

  @doc """
  Update the Worker state.
  """
  def api_set(opts) when is_list(opts) do
    GenServer.call(@proc_name, {:set, opts})
  end

  @doc """
  Return the Worker state.
  """
  def api_state do
    GenServer.call(@proc_name, :state)
  end

  @doc """
  Returns true if the Worker command is running.
  """
  def api_running? do
    GenServer.call(@proc_name, :task)
  end

  @doc """
  Return the PID of the running worker command.
  """
  def api_task do
    GenServer.call(@proc_name, :task)
  end

  @doc false
  def api_task_await do
    GenServer.call(@proc_name, :task_await)
  end

  @doc false
  def api_pidinfo do
    GenServer.call(@proc_name, :pidinfo)
  end

  # ----- callbacks

  @impl true
  def handle_info({_ref, _data}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_call({:start, opts}, _from, state) do
    optsmap = opts |> to_map()
    if state.task, do: Task.shutdown(state.task, :brutal_kill)
    new_state = state |> Map.merge(optsmap)
    new_task = new_state |> start_cmd()
    {:reply, new_task, %{new_state | task: new_task}}
  end

  @impl true
  def handle_call(:stop, _from, state) do
    if state.task do
      stop_cmd(state)
      if state.prompt do
        IO.write(state.prompt)
      end
    end
    {:reply, :ok, %Worker{state | task: nil}}
  end

  @impl true
  def handle_call(:kill, _from, state) do
    {:stop, :normal, state, state}
  end

  @impl true
  def handle_call({:set, opts}, _from, state) do
    optsmap = opts |> to_map()
    new_state = Map.merge(state, optsmap)
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:task, _from, %{task: task} = state) do
    {:reply, task, state}
  end

  @impl true
  def handle_call(:task_await, _from, %{task: task} = state) do
    result = case task do
      nil -> nil
      value -> Task.await(value)
    end
    {:reply, result, state}
  end

  @impl true
  def handle_call(:pidinfo, _from, %{task: task} = state) do
    info = case task do
      nil -> nil
      task -> Process.info(task.pid)
    end
    {:reply, info, state}
  end

  # called when the task exits
  @impl true
  def handle_cast(:exit, state) do
    if state.task && state.prompt do
      IO.write(state.prompt)
    end
    {:noreply, %Worker{state | task: nil}}
  end

  # ----- helpers

  # launch a new command
  defp start_cmd(%{cmd: nil} = _state) do
    nil
  end

  defp start_cmd(state) do
    [cmd | args] = state.cmd |> OptionParser.split()
    clearscreen = "\x1Bc"
    if state.clearscreen, do: IO.write(clearscreen)
    Task.async(fn ->
      result = MuonTrap.cmd(cmd, args, into: IO.stream())
      api_exit()
      result
    end)
  end

  # stop a running command
  defp stop_cmd(nil), do: :ok

  defp stop_cmd(state) do
    Task.shutdown(state.task, :brutal_kill)
  end

  defp set_state(opts) when is_map(opts) do
    %Worker{
      task:        Map.get(opts, :task, nil),
      cmd:         Map.get(opts, :cmd, nil),
      prompt:      Map.get(opts, :prompt, nil),
      clearscreen: Map.get(opts, :clearscreen, nil)
    }
  end

  defp set_state(opts) when is_list(opts) do
    %Worker{
      task:        Keyword.get(opts, :task, nil),
      cmd:         Keyword.get(opts, :cmd, nil),
      prompt:      Keyword.get(opts, :prompt, nil),
      clearscreen: Keyword.get(opts, :clearscreen, nil)
    }
  end

  defp to_map(opts) when is_list(opts) do
    opts |> Enum.into(%{})
  end

  defp to_map(opts) when is_map(opts) do
    opts
  end

end
