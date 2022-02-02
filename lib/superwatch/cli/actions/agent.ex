defmodule Superwatch.Cli.Actions.Agent do

  @moduledoc """
  Agent - list, edit, select
  "agent save <name>
  """

  @agentfile "~/.superwatch.yml" |> Path.expand()

  def handle(["agent", "edit"]) do
    Util.Editor.launch(@agentfile)
    do_prompt()
  end

  def handle(["agent", "list"]) do
    path = "~/.superwatch.yml" |> Path.expand()
    exe  = "cat" |> System.find_executable()
    {data, _status} = System.cmd(exe, [path])
    IO.puts("\n" <> data <> "\n")
    do_prompt()
  end

  def handle(["agent", "select", target]) do
    IO.puts("Selecting #{target}")
    IO.puts("UNDER CONSTRUCTION")
    do_prompt()
  end

  def handle(value) do
    output = Enum.join(value, " ")
    IO.puts("Unknown Agent Option (#{output})")
    do_prompt()
  end

  # ----- helpers

  defdelegate do_prompt, to: Superwatch.Cli.Repl

end
