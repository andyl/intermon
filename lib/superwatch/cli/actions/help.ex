defmodule Superwatch.Cli.Actions.Help do

  def handle(["?"]    = _args), do: handle(~w(help))
  def handle(["help"]) do
    IO.puts(
      """

      Superwatch Options
        run           - rerun worker
        state         - show REPL state
        agent         - list, load, save Agents
        set           - set Agent options
        reset         - reset Agent defaults
        exit          - quit Superwatch
        help <option> - help on an Option

      """
    )
    do_prompt()
  end

  def handle(["help", "run" | _opts]) do
    IO.puts(
      """

      run
        runs the worker
        also <CR> runs the worker...
      """
    )
    do_prompt()
  end

  def handle(["help", "state" | _opts]) do
    IO.puts(
      """

      state
        return the current application state
      """
    )
    do_prompt()
  end

  def handle(["help", "agent" | _opts]) do
    IO.puts(
      """

      agent - manage agents: list/save/use

        agent list           - list currently defined agents
        agent edit           - edit agents config file (~/.superwatch.yml)
        agent use <agent>    - use an agent
      """
    )
    do_prompt()
  end

  def handle(["help", "set" | _opts]) do
    IO.puts(
      """

      set
        set agent options
      """
    )
    do_prompt()
  end

  def handle(["help", "reset" | _opts]) do
    IO.puts(
      """

      reset
        reset agent options to default
      """
    )
    do_prompt()
  end

  def handle(["help", "exit" | _opts]) do
    IO.puts(
      """

      exit
        quit superwatch
      """
    )
    do_prompt()
  end

  # ----- unhandled input

  def handle(value) do
    output = Enum.join(value, " ")
    IO.puts("\nUnknown help option (#{output})\n")
    do_prompt()
  end

  # ----- helpers

  defdelegate do_prompt, to: Superwatch.Cli.Repl

end
