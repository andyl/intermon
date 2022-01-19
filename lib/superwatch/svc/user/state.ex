defmodule Superwatch.Svc.User.State do

  use GenServer 

  alias Util.MapUtil

  # ----- setup

  def start_link(prefs \\ %{}) do 
    GenServer.start_link(__MODULE__, prefs, name: __MODULE__)
  end

  @impl true
  def init(prefs \\ %{}) do
    new_prefs = prefs_map() |> prefs_update(prefs)
    {:ok, %{prefs: new_prefs}}
  end

  # ----- api 

  def prefs do 
    GenServer.call(__MODULE__, :prefs) 
  end

  def set_pref(key, value) do 
    GenServer.call(__MODULE__, {:set_pref, key, value})
  end

  # ----- callbacks 

  @impl true 
  def handle_call(:prefs, _from, %{prefs: prefs} = state) do 
    {:reply, prefs, state}
  end

  @impl true 
  def handle_call({:set_pref, key, value}, _from, %{prefs: prefs} = state) do 
    new_prefs = prefs_update(prefs, %{key => value})
    new_state = %{state | prefs: new_prefs}

    {:reply, :ok, new_state}
  end

  # ----- helpers
  
  defp state_file do
    # tmp file copied from priv dir for tests 
    # see 'test / setup' block for details
    case Application.get_env(:superwatch, :env) do 
      :test -> "/tmp/superwatch_test_state.yml"
      _ -> "./superchat_state.yml" |> Path.expand()
    end
  end

  defp prefs_map(data \\ read_yaml()) do
    new_data = data |> MapUtil.atomify_keys()
    %{
      agent:         Map.get(new_data, :agent        , ""), 
      worker_flags:  Map.get(new_data, :worker_flags , ""), 
      worker_opts:   Map.get(new_data, :worker_opts  , ""), 
      monitor_opts:  Map.get(new_data, :monitor_opts , ""), 
      monitor_flags: Map.get(new_data, :monitor_flags, ""), 
    } 
  end

  defp prefs_update(old_prefs, new_prefs) do 
    op = old_prefs |> MapUtil.atomify_keys()
    np = new_prefs |> MapUtil.atomify_keys()
    clean = op |> Map.merge(np) |> prefs_map()
    if clean != old_prefs, do: write_yaml(clean)
    clean
  end

  defp read_yaml do
    case File.exists?(state_file()) do
      true -> state_file() |> File.read!()
      _ -> ""
    end 
    |> YamlElixir.read_from_string!() |> MapUtil.atomify_keys()
  end

  def write_yaml(prefs) do 
    yaml = prefs |> Ymlr.document!()
    File.write!(state_file(), yaml)
  end

end

