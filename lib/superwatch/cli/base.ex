defmodule Superwatch.Cli.Base do

  def main([]) do
    help()
  end

  def main([arg]) do
    case arg do
      "start" -> start()
      "help"  -> help()
      arg     -> IO.puts("Unrecognized: #{arg} (try 'superwatch help')")
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
    Superwatch.Api.start()
    Superwatch.Cli.Repl.start()
  end
end
