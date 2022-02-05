defmodule Superwatch.Svc.AppSup do
  use Supervisor

  alias Superwatch.Svc.Store
  alias Superwatch.Svc.{Worker, Watcher}

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(args \\ []) do

    base_children = [
      {Store, args},
      {Worker, [prompt: "Superwatch > "]},
      {Watcher, args}
    ]

    children = case Application.get_env(:superwatch, :env) do
      :test -> []
      _  -> base_children
    end

    Supervisor.init(children, strategy: :one_for_one)
  end
end
