defmodule Util.Editor do

   @doc """
   Launch editor with file, blocks until editor closes.
   """
   def launch(file) when is_binary(file) do
     exe = {:spawn_executable, terminal_executable()}
     opt = [:exit_status, :binary, :nouse_stdio, args: args(file)]
     # launch editor
     Port.open(exe, opt)
     receive do
       message -> IO.inspect(message, label: "EDITOR LAUNCH")
     end
     :ok
   end

   @doc """
   Launch editor without file, blocks until editor closes.
   """
   def launch() do
     launch("")
   end

   # -----

   defp args(file) do
     ["--execute", editor_executable(), file]
   end

   defp terminal_executable do
     System.get_env("TERMINAL")
     |> System.find_executable()
   end

   defp editor_executable do
     System.get_env("EDITOR")
     |> System.find_executable()
   end

end

