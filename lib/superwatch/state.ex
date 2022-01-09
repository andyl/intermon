defmodule Superwatch.State do

  defstruct [
    :import, 
    :desc, 
    :monitor_command, 
    :worker_command,
    :worker_exit,
    :worker_flags,
    :worker_opts, 
    :monitor_flags,
    :monitor_opts 
  ]

end
