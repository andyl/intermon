defmodule Superwatch.Cli.Repl do

  alias Superwatch.Api

  alias Superwatch.Cli.Actions

  def start() do
    loop()
  end

  defp loop do
    prompt_input = IO.gets("") |> String.trim()
    case prompt_input do
      "exit"  -> do_exit()
      "xx"    -> do_exit()
      "run"   -> do_worker()
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
end
