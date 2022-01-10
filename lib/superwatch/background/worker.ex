defmodule Superwatch.Background.Worker do
  use GenServer

  defstruct [:port, :cmd]

  alias Superwatch.Background.Worker

  # ----- setup / shutdown

  def start_link(cmd \\ "") do 
    GenServer.start_link(__MODULE__, cmd, name: __MODULE__)
  end

  @impl true
  def init(cmd \\ "") do
    port = start_port(cmd)
    {:ok, %Worker{cmd: cmd, port: port}}
  end

  @impl true 
  def terminate(_reason, %{port: nil} = _state) do
    :normal
  end

  @impl true 
  def terminate(_reason, %{port: port} = _state) do
    Port.close(port)
    :normal
  end

  # ----- callbacks 

  @impl true
  def handle_info({_port, {:data, data}}, state) do 
    IO.write data
    {:noreply, state}
  end

  @impl true
  def handle_info({_port, {:exit_status, 0}}, state) do 
    IO.puts("WORKER DONE")
    {:noreply, state}
  end

  @impl true
  def handle_info({_port, {:exit_status, status}}, state) do 
    IO.puts("WORKER ERROR -> status #{status}")
    {:noreply, state}
  end

  @impl true 
  def handle_call({:start, cmd}, _from, %{port: old_port} = state) do 
    if old_port, do: Port.close(old_port)
    new_port = start_port(cmd)
    {:reply, :ok, %Worker{state | port: new_port}}
  end

  @impl true 
  def handle_call(:stop, _from, %{port: old_port} = state) do 
    if old_port, do: Port.close(old_port)
    {:reply, :ok, %Worker{state | port: nil}}
  end

  @impl true
  def handle_call(:state, _from, state) do 
    {:reply, state, state}
  end

  @impl true
  def handle_call(:port, _from, %{port: port} = state) do 
    {:reply, port, state}
  end
  
  # ----- api
  
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
    GenServer.call(__MODULE__, :port)
  end

  # ----- helpers

  def start_port(cmd) do 
    Port.open({:spawn, cmd}, [:stderr_to_stdout, :binary, :exit_status])
  end
  
  # defp write_prompt({prompt_string, exit_regex}, data) do
  #   if data =~ exit_regex do
  #     IO.puts(prompt_string)
  #   end
  # end

end
