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

  def gen(data) do
    %Agent{
      desc:          Map.get(data, "desc", ""),
      include:       Map.get(data, "include", ""),
      watch_dirs:    Map.get(data, "dirs", ""),
      watch_ftypes:  Map.get(data, "ftypes", ""),
      watch_filters: Map.get(data, "filters", ""),
      clearscreen?:  Map.get(data, "clearscreen", ""),
      worker_cmd:    Map.get(data, "command", ""),
      worker_flags:  Map.get(data, "worker_flags", []),
      worker_args:   Map.get(data, "worker_args", %{})
    }
  end

end
