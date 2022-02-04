defmodule Superwatch.Svc.User.Agents do

  @moduledoc """
  Maintains live config info - a list of agent configs.

  The source of config info is a yaml file.
  - test: priv/superwatch.yml
  - prod/dev: ~/.superwatch.yaml
  """

  use GenServer

  @proc_name :agents_proc

  alias Util.MapUtil

  # ----- setup

  def start_link(config \\ []) when is_list(config) do
    GenServer.start_link(__MODULE__, config, name: @proc_name)
  end

  @doc false
  @impl true
  def init(config \\ []) when is_list(config) do
    new_config = config_map() |> config_update(config)
    {:ok, %{config: new_config}}
  end

  @doc false
  @impl true
  def terminate(_reason, _state) do
    :normal
  end

  # ----- api

  @doc """
  Returns the config data.
  """
  def api_config do
    GenServer.call(@proc_name, :config)
  end

  @doc """
  Returns the config yaml.  No interaction with GenServer.
  """
  def api_config_yaml do
    read_yaml()
  end

  @doc """
  Find an agent.
  """
  def api_find(target) when is_binary(target) do
    target
    |> MapUtil.atomify_keys()
    |> api_find()
  end

  def api_find(target) when is_atom(target) do
    case api_config()[target] do
      nil -> :error
      val -> {:ok, val}
    end
  end

  @doc """
  Updates the config data.  Used for testing.

  Applies config opts to the current state.
  """
  def api_update(cfg_opts \\ []) do
    GenServer.call(@proc_name, {:update, cfg_opts})
  end

  @doc """
  Reloads config data.  Called after the user edits the config file.

  Optionally apply config opts to the state.
  """
  def api_reload(config \\ []) do
    GenServer.call(@proc_name, {:reload, config})
  end

  # ----- callbacks

  @doc false
  @impl true
  def handle_call(:config, _from, %{config: config} = state) do
    {:reply, config, state}
  end

  @doc false
  @impl true
  def handle_call({:update, new_cfg}, _from, %{config: old_cfg} = _state) do
    new_config = old_cfg |> config_update(new_cfg)
    {:reply, new_config, %{config: new_config}}
  end

  @doc false
  @impl true
  def handle_call({:reload, new_cfg}, _from, _state) do
    new_config = config_map() |> config_update(new_cfg)
    {:reply, new_config, %{config: new_config}}
  end

  # ----- helpers

  defp config_file do
    case Application.get_env(:superwatch, :env) do
      :test -> Application.app_dir(:superwatch) <> "/priv/superwatch.yml"
      _ -> "~/.superwatch.yml" |> Path.expand()
    end
  end

  defp read_yaml do
    tgt_file = config_file()
    case File.exists?(tgt_file) do
      true -> tgt_file |> File.read!()
      _ -> ""
    end
  end

  defp read_data do
    read_yaml()
    |> YamlElixir.read_from_string!()
    |> MapUtil.atomify_keys()
  end

  defp config_map(data \\ read_data()) do
    data |> MapUtil.atomify_keys()
  end

  defp config_update(old_config, new_config) do
    op = old_config |> MapUtil.atomify_keys()
    np = new_config |> MapUtil.atomify_keys()
    op |> Map.merge(np) |> config_map()
  end

end
