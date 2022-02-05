defmodule Superwatch.Cli.Actions.Prefs do

  @moduledoc """
  Cli.Actions.Prefs - show, edit, reset
  """

  # @prefsfile "./.superwatch_prefs.yml" |> Path.expand()

#   def handle(["prefs", "edit"]) do
#     Util.Editor.launch(@prefsfile)
#     do_prompt()
#   end
#
#   def handle(["prefs", "show"]) do
#     Superwatch.Api.prefs_show() |> IO.inspect()
#     do_prompt()
#   end

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
