defmodule Superwatch.Cli.Actions.Agent do

  @moduledoc """
  Agent - list, save, load
  "agent save <name>
  """

  def handle(value) do
    output = Enum.join(value, " ")
    IO.puts("Unknown Agent Option (#{output})")
    do_prompt()
  end

  # ----- helpers

  defdelegate do_prompt, to: Superwatch.Cli.Repl

end
