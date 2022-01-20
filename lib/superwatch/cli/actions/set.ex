defmodule Superwatch.Cli.Actions.Set do
  
  # ----- unhandled input

  def handle(value) do
    output = Enum.join(value, " ")
    IO.puts("Unknown Set Option (#{output})")
    do_prompt()
  end

  # ----- helpers 
  
  defdelegate do_prompt, to: Superwatch.Cli.Repl

end
