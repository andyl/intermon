defmodule Superwatch.Svc.Supervisor do
  use Supervisor 

  # alias Superwatch.Svc.User.{Config, State}
  alias Superwatch.Svc.{Worker, Monitor}

  def start_link(_args) do 
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true 
  def init(args \\ []) do 

    base_children = [
    #   {Config, args}, 
    #   {State, args}, 
      {Worker, [prompt: "Superwatch > "]}, 
      {Monitor, args}
    ]

    children = case Application.get_env(:superwatch, :env) do
      :test -> []
      _  -> base_children
    end

    Supervisor.init(children, strategy: :one_for_one)
  end
end
