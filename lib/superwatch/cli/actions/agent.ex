defmodule Superwatch.Cli.Actions.Agent do

  alias Superwatch.Cli.Repl
  alias Superwatch.Svc.Store

  @moduledoc """
  Cli.Actions.Agent - list, edit, select
  """

  def handle(["agent", "edit"]) do
    Store.api_root_file()
    |> Path.expand()
    |> Util.Editor.launch()
    Repl.do_prompt()
  end

  def handle(["agent", "list"]) do
    header = ~w(Agent Description Active?)
    rows = Superwatch.Api.agent_list()
    TableRex.quick_render!(rows, header) <> "\n"
    |> IO.puts()
    do_prompt()
  end

  def handle(["agent", "select", _target]) do
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
