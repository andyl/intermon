defmodule Superwatch.Background.Supervisor do
  use Supervisor 

  # alias Superwatch.User.{Config, State}
  # alias Superwatch.Background.{Manager, Worker}
  alias Superwatch.Background.{Runner, Monitor}

  def start_link(_args) do 
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true 
  def init(args \\ []) do 

    base_children = [
    #   {Config, args}, 
    #   {State, args}, 
      {Runner, [streamio: true, prompt: "bong > "]}, 
      {Monitor, args}
    ]

    children = case Application.get_env(:superwatch, :env) do
      :test -> []
      _  -> base_children
    end

    Supervisor.init(children, strategy: :one_for_one)
  end
end
