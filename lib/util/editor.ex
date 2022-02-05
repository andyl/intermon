defmodule Util.Editor do

   @doc """
   Launch editor with file, blocks until editor closes.
   """
   def launch(file) when is_binary(file) do
     exe = {:spawn_executable, editor_executable()}
     opt = [:exit_status, :binary, :nouse_stdio, args: [file]]
     # launch editor
     Port.open(exe, opt)
     # block until editor closes
     receive do
       _message -> :ok
     end
   end

   @doc """
   Launch editor without file, blocks until editor closes.
   """
   def launch() do
     launch("")
   end

   # -----

   defp editor_executable do
     System.get_env("EDITOR")
     |> System.find_executable()
   end

end

