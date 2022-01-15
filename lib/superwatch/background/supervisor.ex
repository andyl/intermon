defmodule Superwatch.Background.Supervisor do
  use Supervisor 

  # alias Superwatch.User.{Config, State}
  # alias Superwatch.Background.{Manager, Worker}

  def start_link(args \\ %{}) do 
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true 
  def init(_args \\ %{}) do 

    base_children = []
    #   {Config, args}, 
    #   {State, args} 
    # ]

    test_children = []
    #   {Manager, args}, 
    #   {Worker, args}
    # ]

    children = case Application.get_env(:superwatch, :env) do
      :test -> test_children 
      _  -> base_children ++ test_children
    end

    # IO.inspect(children, label: "STARTUP CHILDREN") 

    # MuonTrap.Port.cmd(asdf)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
