defmodule Superwatch.Cli.Actions.Help do
  
  def handle(["?"]    = _args), do: handle(~w(help))
  def handle(["help"] = _args) do
    IO.puts(
      """

      Superwatch Options
        run           - rerun worker 
        state         - show REPL state
        reset         - reset Agent
        exit          - quit Superwatch
        help <option> - help on an Option

      """
    )
    do_prompt()
  end

  # ----- unhandled input

  def handle(value) do
    output = Enum.join(value, " ")
    IO.puts("Unknown Help Option (#{output})")
    do_prompt()
  end

  # ----- helpers 
  
  defdelegate do_prompt, to: Superwatch.Cli.Repl

end
