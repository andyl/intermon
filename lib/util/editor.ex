defmodule Util.Editor do

   @doc """
   Launch editor with file, blocks until editor closes.
   """
   def launch(file) when is_binary(file) do
     Port.open({:spawn_executable, editor_executable()}, [:binary, :nouse_stdio, args: [file]])
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

