defmodule Superwatch.Cli.Base do

  alias Superwatch.Api
  alias Superwatch.Cli.Repl

  def main([]) do
    help()
  end

  def main([arg]) do
    case arg do
      "start" -> start()
      "help"  -> help()
      arg -> IO.puts("Unrecognized: #{arg} (try 'superwatch help')")
    end
  end

  def help do
    IO.puts """
    Superwatch Help
      start - start an agent
      help  - this command
    """
  end

  def start do
    Api.start()
    Repl.start()
  end
end
