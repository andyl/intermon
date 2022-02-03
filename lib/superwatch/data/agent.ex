defmodule Superwatch.Data.Agent do

  alias Superwatch.Data.Agent

  defstruct [
    :name,
    :desc,
    :include,
    :dirs,
    :ftypes,
    :filters,
    :clearscreen,
    :command,
    :worker_flags,
    :worker_args
  ]

  def gen({name, data}) do
    gen(name, data)
  end

  def gen(name, data) do
    %Agent{
      name: name,
      desc: Map.get(data, "desc", ""),
      include: Map.get(data, "include", ""),
      dirs: Map.get(data, "dirs", ""),
      ftypes: Map.get(data, "ftypes", ""),
      filters: Map.get(data, "filters", ""),
      clearscreen: Map.get(data, "clearscreen", ""),
      command: Map.get(data, "command", ""),
      worker_flags: Map.get(data, "worker_flags", []),
      worker_args: Map.get(data, "worker_args", %{})
    }
  end

end
