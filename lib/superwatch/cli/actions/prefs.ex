defmodule Superwatch.Cli.Actions.Prefs do

  @moduledoc """
  Cli.Actions.Prefs - show, edit, reset
  """

  alias Superwatch.Cli.Repl
  alias Superwatch.Svc.Store

  def handle(["prefs", "edit"]) do
    Store.api_overlay_file()
    |> Path.expand()
    |> Util.Editor.launch()
    Repl.do_prompt()
  end

  def handle(["prefs", "show"]) do
    Superwatch.Api.prefs_show() |> IO.inspect()
    do_prompt()
  end

  def handle(["prefs", "reset"]) do
    IO.puts("UNDER CONSTRUCTION")
    do_prompt()
  end

  def handle(value) do
    output = Enum.join(value, " ")
    IO.puts("Unknown Set Option (#{output})")
    do_prompt()
  end

  # ----- helpers

  defdelegate do_prompt, to: Superwatch.Cli.Repl

end
