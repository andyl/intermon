defmodule Superwatch.Cli.Actions.Help do

  def handle(["?"]    = _args), do: handle(~w(help))
  def handle(["help"]) do
    IO.puts(
      """

      Superwatch Options
        run           - rerun worker
        agent         - list / edit
        prefs         - show / edit
        clear         - clear screen
        reload        - reload configs
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

  def handle(["help", "prefs" | _opts]) do
    IO.puts(
      """

      prefs - manage preferences

        prefs show - show preferences
        prefs edit - edit preferences
      """
    )
    do_prompt()
  end

  def handle(["help", "agent" | _opts]) do
    IO.puts(
      """

      agent - manage agents

        agent show - show the active agent
        agent list - list all defined agents
        agent edit - edit agents config file (~/.superwatch.yml)
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
    IO.puts("\nUnknown option ('#{output}')")
    handle(~w(help))
    do_prompt()
  end

  # ----- helpers

  defdelegate do_prompt, to: Superwatch.Cli.Repl

end
