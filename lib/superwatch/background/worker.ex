defmodule Superwatch.Background.Worker do
  use GenServer

  defstruct [:pid, :cmd]

  alias Superwatch.Background.{Worker, Manager}

  # ----- startup / shutdown

  def start_link(cmd \\ "") do 
    launch_cmd = case cmd do 
      "" -> Manager.command 
      cmd -> cmd
    end
    GenServer.start_link(__MODULE__, launch_cmd, name: __MODULE__)
  end

  def init do 
    init("")
  end 

  @impl true
  def init(cmd) when is_binary(cmd) do
    pid = case cmd do
      "" -> nil
      cmd -> start_cmd(cmd)
    end
    {:ok, %Worker{cmd: cmd, pid: pid}}
  end

  def init(cmd) when is_map(cmd) do
    Manager.command() |> init()
  end

  @impl true 
  def terminate(_reason, %{pid: nil} = _state) do
    IO.puts "TERMINATE NOPORT"
    :normal
  end

  @impl true 
  def terminate(_reason, %{pid: _pid} = _state) do
    # IO.inspect(pid, label: "TERMINATE PORT") 
    # IO.inspect(state, label: "TERMINATE STATE") 
    :normal
  end

  # ----- api

  def start do 
    Manager.command() |> start()
  end
  
  def start(cmd) do 
    GenServer.call(__MODULE__, {:start, cmd}) 
  end

  def stop do
    GenServer.call(__MODULE__, :stop)
  end
  
  def state do
    GenServer.call(__MODULE__, :state)
  end

  def running? do 
    GenServer.call(__MODULE__, :pid)
  end

  def pid do 
    GenServer.call(__MODULE__, :pid)
  end

  def pidinfo do 
    GenServer.call(__MODULE__, :pidinfo) 
  end

  # ----- callbacks 

  @impl true 
  def handle_call({:start, cmd}, _from, %{pid: old_pid} = state) do 
    if old_pid, do: stop_cmd(old_pid)
    new_pid = start_cmd(cmd)
    {:reply, :ok, %Worker{state | cmd: cmd, pid: new_pid}}
  end


  @impl true 
  def handle_call(:stop, _from, %{pid: old_pid} = state) do 
    if old_pid, do: stop_cmd(old_pid)
    {:reply, :ok, %Worker{state | cmd: "", pid: nil}}
  end

  @impl true
  def handle_call(:state, _from, state) do 
    {:reply, state, state}
  end

  @impl true
  def handle_call(:pid, _from, %{pid: pid} = state) do 
    {:reply, pid, state}
  end

  @impl true
  def handle_call(:pidinfo, _from, %{pid: pid} = state) do 
    info = Process.info(pid)
    {:reply, info, state}
  end
  
  # ----- helpers


  def start_cmd(cmd) do 
    # cmd |> IO.inspect(label: "START_CMD") 
    [cmd | args] = cmd |> OptionParser.split() #|> IO.inspect(label: "START_MuT")
    spawn(fn -> 
      MuonTrap.cmd(cmd, args, into: Util.Io.stream())
    end)
  end

  def stop_cmd(nil), do: :ok 

  def stop_cmd(pid) do 
    Process.exit(pid, :kill)
  end
  
end
