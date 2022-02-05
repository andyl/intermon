defmodule Superwatch.Cli.Actions.Core do

  # alias Superwatch.Cli.Actions

#   def handle(["?" | _]     = args), do: Actions.Help.handle(args)
#   def handle(["help" | _]  = args), do: Actions.Help.handle(args)
#   def handle(["agent" | _] = args), do: Actions.Agent.handle(args)
#   def handle(["prefs" | _] = args), do: Actions.Prefs.handle(args)
#
#   def handle(~w(reset)), do: do_reset()

  # ----- unknown value

  def handle(value) do
    output = Enum.join(value, " ")
    IO.puts("Unknown Option (#{output})")
    do_prompt()
  end

  # ----- helpers

  defdelegate do_prompt, to: Superwatch.Cli.Repl

  # defp do_reset do
  #   IO.puts("----- Under Construction -----")
  #   do_prompt()
  # end


end
