defmodule Superwatch.Cli.Actions.Agent do

  alias Superwatch.Api

  @moduledoc """
  Cli.Actions.Agent - list, edit, select
  """

  @agentfile "~/.superwatch.yml" |> Path.expand()

  def handle(["agent", "edit"]) do
    Util.Editor.launch(@agentfile)
    do_prompt()
  end

  def handle(["agent", "list"]) do
    header = ~w(Agent Description)
    rows = Api.agent_list()
    TableRex.quick_render!(rows, header) <> "\n"
    |> IO.puts()
    do_prompt()
  end

  def handle(["agent", "select", target]) do
    IO.puts("Selecting #{target}")
    case Api.agent_select(target) do
      {:error, msg} -> IO.puts("Error: #{msg}")
      _ -> IO.puts("Selected: #{target}")
    end
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
