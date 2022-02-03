defmodule Superwatch.Cli.Repl do

  alias Superwatch.Api

  alias Superwatch.Cli.Actions

  def start() do
    loop()
  end

  defp loop do
    prompt_input = IO.gets("") |> String.trim()
    case prompt_input do
      "prefs" -> do_prefs()
      "exit"  -> do_exit()
      "xx"    -> do_exit()
      ""      -> do_worker()
      value   -> value |> OptionParser.split() |> Actions.Core.handle()
    end
    loop()
  end

  # ----- helpers

  def do_prompt do
    Superwatch.Sys.prompt() |> IO.write()
  end

  # ----- private

  defp do_worker do
    Api.run()
  end

  defp do_exit do
    IO.puts("EXITING")
    System.halt(0)
  end

  defp do_prefs do
    Api.prefs()
    do_prompt()
  end
end
