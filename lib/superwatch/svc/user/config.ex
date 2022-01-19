defmodule Superwatch.Svc.User.Config do

  use GenServer 

  alias Util.MapUtil

  # ----- setup  

  def start_link(config \\ %{}) do 
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  @impl true
  def init(config \\ %{}) do
    new_config = config_map() |> config_update(config)
    {:ok, %{config: new_config}}
  end

  @impl true
  def terminate(_reason, _state) do
    :normal
  end

  # ----- api 

  def config do
    GenServer.call(__MODULE__, :config)
  end

  # ----- callbacks 

  @impl true 
  def handle_call(:config, _from, %{config: config} = state) do 
    {:reply, config, state}
  end

  # ----- helpers 
  
  defp config_file do
    case Application.get_env(:superwatch, :env) do 
      :test -> Application.app_dir(:superwatch) <> "/priv/superwatch.yml"
      _ -> "~/superwatch.yml" |> Path.expand()
    end
  end

  defp read_yaml do
    tgt_file = config_file()
    case File.exists?(tgt_file) do
      true -> tgt_file |> File.read!()
      _ -> ""
    end 
    |> YamlElixir.read_from_string!() 
    |> MapUtil.atomify_keys() 
  end

  defp config_map(data \\ read_yaml()) do
    data |> MapUtil.atomify_keys()
  end

  defp config_update(old_config, new_config) do 
    op = old_config |> MapUtil.atomify_keys()
    np = new_config |> MapUtil.atomify_keys()
    op |> Map.merge(np) |> config_map()
  end

end
