defmodule Superwatch.Background.Monr do

  use GenServer

  alias Superwatch.Background.Monr

  defstruct [:cmd, :monpid, :monopt, :pid]

  @moduledoc """
  Monitor / Runner 

  Opts:
  - dirs        - monitor dirs
  - filetypes   - ex,exs,etc.
  - filter      - filename patterns
  - clearscreen - boolean
  """

  # ----- startup / shutdown 
  
  def start_link(opts \\ %{}) do 
    GenServer.start_link(__MODULE__, opts, __MODULE__)
  end 

  @impl true
  def init(opts) do 
    command = Map.get(opts, :cmd, "")

    monopt = %{
      dirs: Map.get(opts, :dirs, []), 
      ftypes: Map.get(opts, :ftypes, []), 
      filter: Map.get(opts, :filter, []), 
      clearscreen: Map.get(opts, :clearscreen, false)
    }

    monpid = case command do 
      "" -> nil 
      _ -> monopt |> start_mon()
    end
    
    state = %{
      cmd: command, 
      monopt: monopt, 
      monpid: monpid
    }

    {:ok, state}
  end

  # ----- api 

  def start(monopts) do 
    pid = start_mon(monopts)
    GenServer.call(__MODULE__, {:start, pid, monopts}) 
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
  def handle_info({:file_event, _monitor_pid, {_file_path, _events}}, state) do
    
    # TODO: only if file_path matches filter and filetypes
    if true do 
      clearscreen = "\x1Bc"
      if state.opts.clearscreen, do: IO.write(clearscreen)
      # IO.puts "Superwatch\n#{cmd}\n-----------------------------------------------"
      state.cmd |> run_cmd()
    end

    {:noreply, state}
  end

  # @impl true 
  # def handle_call({:start, cmd}, _from, %{pid: old_pid} = state) do 
  #   if old_pid, do: stop_cmd(old_pid)
  #   new_pid = start_cmd(cmd)
  #   {:reply, :ok, %Monr{state | cmd: cmd, pid: new_pid}}
  # end

  @impl true 
  def handle_call(:stop, _from, %{pid: _old_pid} = state) do 
    # if old_pid, do: stop_cmd(old_pid)
    {:reply, :ok, %Monr{state | cmd: "", pid: nil}}
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
  
  def start_mon(opts) do 
    {:ok, pid} = FileSystem.start_link(dirs: opts.dirs)
    FileSystem.subscribe(pid)
    pid
  end

  def stop_mon(nil), do: :ok 

  def stop_mon(pid) do 
    Process.exit(pid, :kill)
  end

  def run_cmd(cmd) do
    [exe | args] = cmd |> OptionParser.split()
    MuonTrap.cmd(exe, args, into: IO.stream())
  end
end
