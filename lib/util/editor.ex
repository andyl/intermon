defmodule Util.Editor do

  @doc """
  Launch editor with file, blocks until editor closes.
  """
  def launch(file) when is_binary(file) do
    Port.open({:spawn_executable, editor()}, [:binary, :nouse_stdio, args: [file]])
  end

  @doc """
  Launch editor without file, blocks until editor closes.
  """
  def launch() do
    Port.open({:spawn_executable, editor()}, [:binary, :nouse_stdio])
  end

  defp editor do
    System.get_env("EDITOR")
    |> System.find_executable()
  end

end
