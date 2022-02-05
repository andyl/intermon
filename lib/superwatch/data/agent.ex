defmodule Superwatch.Data.Agent do

  alias Superwatch.Data.Agent

  defstruct [
    :desc,          # agent description
    :include,       # include another agent
    :watch_dirs,    # directories to watch
    :watch_ftypes,  # file types to watch
    :watch_filters, # filename filters for watcher
    :worker_cmd,    # worker command
    :worker_flags,  # set of worker flags (boolean)
    :worker_args,   # set of worker arguments (k/v)
    :clearscreen?,  # clear before every worker run?
    :active?,       # the active agent
    :pref_flags,    # preference flags
    :pref_args      # preference arguments
  ]

  @doc """
  Generates an agent struct from a map.

  Missing fields are given a nil value.
  """
  def gen(data) do

    datakey = data |> Util.MapUtil.atomify_keys()

    %Agent{
      desc:          get(datakey, :desc          ) ,
      include:       get(datakey, :include       ) ,
      watch_dirs:    get(datakey, :watch_dirs    ) ,
      watch_ftypes:  get(datakey, :watch_ftypes  ) ,
      watch_filters: get(datakey, :watch_filters ) ,
      worker_cmd:    get(datakey, :worker_cmd    ) ,
      worker_flags:  get(datakey, :worker_flags  ) ,
      worker_args:   get(datakey, :worker_args   ) ,
      clearscreen?:  get(datakey, :clearscreen?  ) ,
      active?:       get(datakey, :active?       ) ,
      pref_flags:    get(datakey, :pref_flags    ) ,
      pref_args:     get(datakey, :pref_args     ) ,
    }
  end

  def to_map(agent) when is_struct(agent), do: Map.from_struct(agent)
  def to_map(agent) when is_map(agent), do: agent

  def strip(agent) do
    agent
    |> to_map()
    |> Enum.reduce(%{}, fn({key, val}, acc) ->
          if val != nil, do: Map.merge(acc, %{key => val}), else: acc
        end)
  end

  def merge(agent1, agent2) do
    agent1 |> Map.merge(strip(agent2))
  end

  # -----

  defp get(data, field) do
    Map.get(data, field, nil)
  end

end
