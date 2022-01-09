defmodule Superwatch.Background.Manager do
  use GenServer

  # ----- setup

  def start_link(args \\ %{}) do 
    GenServer.start_link(__MODULE__, args)
  end

  @impl true
  def init(args \\ %{}) do
    {:ok, args}
  end

  # ----- callbacks 
  @impl true
  def handle_call(:state, _from, state) do 
    {:reply, state, state}
  end
  
  # ----- api
  def state do 
    GenServer.call(__MODULE__, :state)
  end

end
