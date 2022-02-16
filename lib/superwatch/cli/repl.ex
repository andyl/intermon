defmodule Superwatch.Cli.Repl do

  alias Superwatch.Cli.Actions

  def start() do
    do_prompt()
    loop()
  end

  defp loop do
    prompt_input = IO.gets("") |> String.trim()
    case prompt_input do
      "exit"   -> do_exit()
      "xx"     -> do_exit()
      "run"    -> do_worker()
      "reload" -> do_reload()
      "clear"  -> do_clear()
      "cls"    -> do_clear()
      ""       -> do_worker()
      value    -> value |> OptionParser.split() |> Actions.Core.handle()
    end
    loop()
  end

  # ----- helpers

  def do_prompt do
    Superwatch.Sys.prompt() |> IO.write()
  end

  def do_clear do
    IO.puts IO.ANSI.clear()
    IO.puts IO.ANSI.cursor(0,0)
    do_prompt()
  end

  def do_reload do
    Superwatch.Api.reload()
    do_prompt()
  end

  # ----- private

  defp do_worker do
    Superwatch.Api.run()
  end

  defp do_exit do
    IO.puts("EXITING")
    System.halt(0)
  end
end
