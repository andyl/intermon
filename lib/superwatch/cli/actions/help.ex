defmodule Superwatch.Cli.Actions.Help do
  
  def handle(["?"]    = _args), do: do_help()
  def handle(["help"] = _args), do: do_help()

  # ----- unhandled input

  def handle(value) do
    output = Enum.join(value, " ")
    IO.puts("Unknown Help Option (#{output})")
    do_prompt()
  end

  # ----- helpers 
  
  defdelegate do_prompt, to: Superwatch.Cli.Repl

  defp do_help do
    IO.puts(
      """

      Superwatch Help
        <CR>    - rerun worker 
        state   - show REPL state
        exit    - quit Superwatch
        reset   - reset Agent
        ?       - help (this command)
      """
    )
    do_prompt()
  end
  
end
