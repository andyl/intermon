defmodule Superwatch.Agent do

  alias Superwatch.Agent

  defstruct [
    :name, 
    :desc, 
    :include, 
    :monitor_command, 
    :worker_command,
    :worker_exit,
    :worker_flags,
    :worker_opts, 
    :monitor_flags,
    :monitor_opts 
  ]

  def gen({name, data}) do 
    gen(name, data)
  end

  def gen(name, data) do 
    %Agent{
      name: name, 
      desc: Map.get(data, "desc", ""), 
      include: Map.get(data, "import", ""), 
      monitor_command: Map.get(data, "import", ""), 
      worker_command: Map.get(data, "worker_command", ""), 
      worker_exit: Map.get(data, "worker_exit", ""), 
      worker_flags: Map.get(data, "worker_flags", ""), 
      worker_opts:  Map.get(data, "worker_opts", ""), 
      monitor_flags: Map.get(data, "monitor_flags", ""), 
      monitor_opts:  Map.get(data, "monitor_opts", ""), 
    }
  end
  
end
