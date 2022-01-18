defmodule Superwatch.Background.Runner do

  use GenServer

  defstruct [:task, :cmd, :prompt, :clearscreen]

  alias Superwatch.Background.Runner

  @moduledoc """
  Runner - content TBD
  """

  # ----- startup / shutdown 

  def start_link, do: start_link([])

  def start_link(cmd) when is_binary(cmd) do
    start_link([cmd: cmd])
  end

  def start_link(opts) when is_list(opts) do 
    state = opts |> set_state()
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
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

  def start, do: start([])

  def start(cmd) when is_binary(cmd) do 
    start([cmd: cmd])
  end

  def start(opts) when is_list(opts) do 
    GenServer.call(__MODULE__, {:start, opts}) 
  end

  def stop do
    GenServer.call(__MODULE__, :stop)
  end

  def exit do
    GenServer.cast(__MODULE__, :exit)
  end

  def set(opts) when is_list(opts) do 
    GenServer.call(__MODULE__, {:set, opts}) 
  end
  
  def state do
    GenServer.call(__MODULE__, :state)
  end

  def running? do 
    GenServer.call(__MODULE__, :task)
  end

  def task do 
    GenServer.call(__MODULE__, :task)
  end

  def task_await do 
    GenServer.call(__MODULE__, :task_await)
  end

  def pidinfo do 
    GenServer.call(__MODULE__, :pidinfo) 
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
    {:reply, :ok, %Runner{state | task: nil}}
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

  @impl true
  def handle_cast(:exit, state) do 
    if state.task && state.prompt do
      IO.write(state.prompt) 
    end
    {:noreply, %Runner{state | task: nil}}
  end
  
  # ----- helpers

  defp start_cmd(%{cmd: nil} = _state) do 
    nil
  end 

  defp start_cmd(state) do 
    [cmd | args] = state.cmd |> OptionParser.split() 
    clearscreen = "\x1Bc"
    if state.clearscreen, do: IO.write(clearscreen)
    Task.async(fn -> 
      result = MuonTrap.cmd(cmd, args, into: IO.stream())
      exit()
      result
    end)
  end

  defp stop_cmd(nil), do: :ok 

  defp stop_cmd(state) do 
    Task.shutdown(state.task, :brutal_kill)
  end

  defp set_state(opts) when is_map(opts) do 
    %Runner{
      task:        Map.get(opts, :task, nil), 
      cmd:         Map.get(opts, :cmd, nil), 
      prompt:      Map.get(opts, :prompt, nil), 
      clearscreen: Map.get(opts, :clearscreen, nil)
    }
  end

  defp set_state(opts) when is_list(opts) do 
    %Runner{
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
