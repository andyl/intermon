defmodule Superwatch.Background.Supervisor do
  use Supervisor 

  alias Superwatch.Background.Manager

  def start_link(args \\ %{}) do 
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true 
  def init(args \\ %{}) do 

    children = [
      {Manager, args}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
