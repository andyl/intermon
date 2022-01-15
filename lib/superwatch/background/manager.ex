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
    wcmd = "mix test --stale --color; echo ---"
    # wcmd = "mix compile --color; echo ---"
    # wcmd = ~s(echo ""; echo CHANGE DETECTED; echo ---)
    case "ex_unit" do 
      "ex_unit" -> ~s[watchexec -c -w lib -w test -e ex,exs,eex,heex "#{wcmd}"]
      "ex_unit_umbrella" -> ~s[watchexec -w apps -e ex,exs,eex,heex "#{wcmd}"]
    end 
  end

  def status do
  end

  # ----- callbacks 

  @impl true
  def handle_call(:state, _from, state) do 
    {:reply, state, state}
  end

end
