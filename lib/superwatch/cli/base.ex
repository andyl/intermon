defmodule Superwatch.Cli.Base do

  alias Superwatch.Sys

  alias Superwatch.Svc.Worker
  alias Superwatch.Svc.Monitor
  alias Superwatch.Cli.Base
  alias Superwatch.Cli.Repl

  def main([]) do 
    help()
  end

  def main([arg]) do
    case arg do 
      "init"  -> init()
      "start" -> Base.start()
      "help"  -> help()
      arg -> IO.puts("Unrecognized: #{arg} (try 'superwatch help')")
    end
  end

  def help do
    IO.puts """
    Superwatch Help
      init   - create a superwatch config file at ~/.superwatch.yml
      start  - start an agent
      help   - this command
    """
  end

  def init do 
    IO.puts("INIT")
  end

  def start do 
    cmd = Sys.command()
    Worker.set(cmd: cmd, clearscreen: true, prompt: Sys.prompt())
    Monitor.start()
    Worker.start()
    Repl.start()
  end
end
