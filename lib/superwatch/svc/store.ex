defmodule Superwatch.Svc.Store do

  @moduledoc """
  Keeps two agent stores:
  - root    <- ~/.superwatch.yml
  - overlay <- ./.superwatch.yml

  The source of config info is a yaml file.
  - test: priv/superwatch.yml
  - prod/dev: ~/.superwatch.yaml

  api:
  - api_root_file
  - api_overlay_file
  - api_root_data
  - api_overlay_data
  - api_merged_data
  - api_active_agent
  - api_select_agent(agent)
  - api_set(field, value)

  state:
  - root_file
  - overlay_file
  - root_data
  - overlay_data
  """

  use GenServer

  @proc_name :store_proc

  alias Util.MapUtil
  alias Superwatch.Data.Agent

  # ----- setup

  def start_link(opts \\ []) when is_list(opts) do
    GenServer.start_link(__MODULE__, opts, name: @proc_name)
  end

  @doc false
  @impl true
  def init(opts \\ []) when is_list(opts) do
    state = opts |> init_state()
    {:ok, state}
  end

  @doc false
  @impl true
  def terminate(_reason, _state) do
    :normal
  end

  # ----- api

  def api_start do
    start_link()
  end

  def api_root_file do
    GenServer.call(@proc_name, :api_root_file)
  end

  def api_overlay_file do
    GenServer.call(@proc_name, :api_overlay_file)
  end

  def api_root_data do
    GenServer.call(@proc_name, :api_root_data)
  end

  def api_overlay_data do
    GenServer.call(@proc_name, :api_overlay_data)
  end

  def api_merged_data do
    root = GenServer.call(@proc_name, :api_root_data)
    over = GenServer.call(@proc_name, :api_overlay_data)
    merge_lists(root, over)
  end

  def api_active_agent do
    overlay = GenServer.call(@proc_name, :api_overlay_data)
    result  = Enum.find(overlay, nil, fn({_, val}) -> val[:active?] end)
    case result do
      {key, _val} -> key
      nil -> first_key(overlay)
    end
  end

  def api_select_agent(_item) do
    :ok
  end

  def api_set(_field, _val) do
    :ok
  end

  def api_reload(opts \\ []) do
    GenServer.call(@proc_name, {:reload, opts})
  end

  # ----- callbacks

  @impl true
  def handle_call(:api_root_file, _from, %{root_file: root_file} = state) do
    {:reply, root_file, state}
  end

  @impl true
  def handle_call(:api_overlay_file, _from, %{overlay_file: overlay_file} = state) do
    {:reply, overlay_file, state}
  end

  @impl true
  def handle_call(:api_root_data, _from, %{root_data: root_data} = state) do
    {:reply, root_data, state}
  end

  @impl true
  def handle_call(:api_overlay_data, _from, %{overlay_data: overlay_data} = state) do
    {:reply, overlay_data, state}
  end

  # @doc false
  # @impl true
  # def handle_call({:update, new_cfg}, _from, %{config: old_cfg} = _state) do
  #   new_config = old_cfg |> config_update(new_cfg)
  #   {:reply, new_config, %{config: new_config}}
  # end

  @impl true
  def handle_call({:reload, opts}, _from, _state) do
    new_state = opts |> init_state()
    {:reply, :ok, new_state}
  end

  # ----- helpers

  # filenames

  def default_root_file do
    case Application.get_env(:superwatch, :env) do
      :test -> Application.app_dir(:superwatch) <> "/priv/superwatch.yml"
      _ -> "~/.superwatch.yml" |> Path.expand()
    end
  end

  def default_overlay_file do
    case Application.get_env(:superwatch, :env) do
      :test -> test_overlay_file()
      _ -> "./.superwatch.yml" |> Path.expand()
    end
  end

  # datafile reading

  def read_yaml(tgt_file) do
    case File.exists?(tgt_file) do
      true -> tgt_file |> File.read!()
      _ -> ""
    end
  end

  def read_data(tgt_file) do
    tgt_file
    |> read_yaml()
    |> YamlElixir.read_from_string!()
    |> MapUtil.atomify_keys()
  end

  # datafile writing

  # defp config_update(old_config, new_config) do
  #   op = old_config |> MapUtil.atomify_keys()
  #   np = new_config |> MapUtil.atomify_keys()
  #   op |> Map.merge(np) |> config_map()
  # end

  # misc helpers

  defp first_key(map) do
    map |> Map.keys() |> List.first()
  end

  # merge root_data (map1) and the overlay_data (map2)
  defp merge_lists(map1, map2) do
    # if there agents in both map1 and map2, they should be merged
    base1 = map1 |> Enum.reduce(%{}, fn({key, val}, acc) ->
        tgt = map2[key] || %{}
        Map.merge(acc, %{key => Agent.merge(val, tgt)})
       end)
    # collect agents that are in map2 but not map1
    base2 = map2 |> Enum.reduce(%{}, fn({key, val}, acc) ->
        tgt = if Map.has_key?(map1, key), do: %{}, else: %{key => val}
        Map.merge(acc, tgt)
    end)
    Map.merge(base1, base2)
  end

  # init_state

  def init_state(opts) do
    root_file    = opts[:root_file] || default_root_file()
    overlay_file = opts[:overlay_file] || default_overlay_file()
    root_data    = read_data(root_file)
    overlay_data = read_data(overlay_file)
    %{
      root_file:    root_file,
      overlay_file: overlay_file,
      root_data:    root_data,
      overlay_data: overlay_data
    }
  end

  # test helper

  def test_overlay_file, do: "/tmp/superwatch_overlay_test.yml"

  # tmp file copied from priv dir for tests
  # see 'test / setup' block for details
  def setup_test_overlay do
    srcfile = Application.app_dir(:superwatch) <> "/priv/superwatch_overlay.yml"
    tgtfile = test_overlay_file()
    File.cp(srcfile, tgtfile)
  end


end
