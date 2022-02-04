defmodule Superwatch.Svc.User.Prefs do

  @moduledoc """
  Maintains user preferences.

  Agents may have user-settable preferences: boolean flags and arguments.

  The state stores the current option, in memory, and persists the preferences
  to disk:
  - test: priv/superwatch_state.yml
  - prod/dev: ~/.superwatch_state.yml

  Preferences:
      agent:         name of current agent
      dirs:          list of monitor directories
      ftypes:        list of monitor filetypes
      filter:        monitor filter
      clearscreen:   clearscreen option
      worker_flags:  list of flags
      worker_args:   map of key/value settings
  """

  use GenServer

  @proc_name :prefs_proc

  alias Util.MapUtil

  # ----- setup

  def start_link(prefs \\ []) do
    GenServer.start_link(__MODULE__, prefs, name: @proc_name)
  end

  @impl true
  def init(prefs \\ []) do
    list = read_data()
    [old_prefs | _] = list
    new_prefs = old_prefs |> prefs_map() |> prefs_update(prefs)
    {:ok, %{list: list, current: new_prefs}}
  end

  # ----- api

  def api_start, do: start_link()

  def api_prefs do
    GenServer.call(@proc_name, :prefs)
  end

  def api_set_prefs(opts) when is_list(opts) do
    GenServer.call(@proc_name, {:set_prefs, opts})
  end

  def api_reset do
    GenServer.call(@proc_name, :reset)
  end

  @doc """
  Selects a preference.

  Steps:
  - pull the target from the prefs list
  - merge the target values onto the agent values
  - prepend the new pref on the prefs list
  - save the changes into the prefs file
  """
  # def api_select(target, agent) do
  #   old_prefs  = api_prefs()
  #   old_agent  = Enum.find(old_prefs, fn(x) -> x.name == target end) || %{}
  #   clean_list = Enum.filter(old_prefs, fn(x) -> x.name != target end)
  #   new_agent  = Merge(
  #
  #   :ok
  # end

  # ----- callbacks

  @impl true
  def handle_call(:prefs, _from, %{current: prefs} = state) do
    {:reply, prefs, state}
  end

  @impl true
  def handle_call({:set_prefs, opts}, _from, %{prefs: prefs} = state) do
    new_prefs = prefs_update(prefs, opts)
    new_state = %{state | prefs: new_prefs}

    {:reply, :ok, new_state}
  end

  # ----- test helper

    # tmp file copied from priv dir for tests
    # see 'test / setup' block for details
  def setup_test_prefs do
    srcfile = Application.app_dir(:superwatch) <> "/priv/superwatch_prefs.yml"
    tgtfile = test_prefs()
    File.cp(srcfile, tgtfile)
  end

  # ----- helpers

  def test_prefs, do: "/tmp/superwatch_test_prefs.yml"

  def state_file do
    case Application.get_env(:superwatch, :env) do
      :test -> test_prefs()
      _ -> "./.superwatch_prefs.yml" |> Path.expand()
    end
  end

  def prefs_map(data) do
    new_data = data |> MapUtil.atomify_keys()
    %{
      agent:         Map.get(new_data, :agent        , ""),
      dirs:          Map.get(new_data, :dirs         , ""),
      ftypes:        Map.get(new_data, :ftypes       , ""),
      filter:        Map.get(new_data, :filter       , ""),
      clearscreen:   Map.get(new_data, :clearscreen  , ""),
      worker_flags:  Map.get(new_data, :worker_flags , ""),
      worker_args:   Map.get(new_data, :worker_args  , ""),
    }
    data
  end

  def prefs_update(old_prefs, new_prefs) do
    op = old_prefs |> MapUtil.atomify_keys()
    np = new_prefs |> MapUtil.atomify_keys()
    clean = op |> Map.merge(np) |> prefs_map()
    if clean != old_prefs, do: write_yaml(clean)
    clean
  end

  def  read_yaml do
    case File.exists?(state_file()) do
      true -> state_file() |> File.read!()
      _ -> ""
    end
  end

  def read_data do
    read_yaml()
    |> YamlElixir.read_from_string!() |> MapUtil.atomify_keys()
  end

  def write_yaml(prefs) do
    yaml = prefs |> Ymlr.document!()
    File.write!(state_file(), yaml)
  end

end

