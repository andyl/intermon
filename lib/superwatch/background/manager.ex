defmodule Superwatch.Background.Manager do

  use GenServer

  # ----- setup

  def start_link(args \\ %{}) do 
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args \\ %{}) do
    state = %{
      prompt: "",
      cmd: "",
      worker_pid: nil,
      worker_port: nil
    }
    {:ok, state}
  end
  
  # ----- api

  def state do 
    GenServer.call(__MODULE__, :state)
  end


  def start do 
  end

  def stop do 
  end

  def prompt() do 
    "Superwatch ('?' for help) > "
  end


  def command do 
    wcmd = "mix test --stale --color"
    # wcmd = "mix compile --color"
    # wcmd = ~s(echo ""; echo CHANGE DETECTED; echo ---)
    wcmd
  end

  def status do
  end

  # ----- callbacks 

  @impl true
  def handle_call(:state, _from, state) do 
    {:reply, state, state}
  end

end
