defmodule Superwatch.Cli.Repl do

  alias Superwatch.Svc.Worker
  alias Superwatch.Svc.Monitor

  alias Superwatch.Cli.Actions

  def start() do
    loop()
  end

  defp loop do
    prompt_input = IO.gets("") |> String.trim()
    case prompt_input do
      "exit"  -> do_exit()
      "xx"    -> do_exit()
      ""      -> do_worker()
      "state" -> do_state()
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
    Worker.start()
  end

  defp do_exit do
    IO.puts("EXITING")
    System.halt(0)
  end

  defp do_state do
    IO.inspect(Worker.state(), label: "WORKER")
    IO.inspect(Monitor.state(), label: "MONITOR")
    do_prompt()
  end
end
