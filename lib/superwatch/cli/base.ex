defmodule Superwatch.Cli.Base do

  alias Superwatch.Background.Manager
  alias Superwatch.Background.Worker
  alias Superwatch.Background.Monitor
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
    cmd = Manager.command()
    Worker.set(cmd: cmd, clearscreen: true, prompt: Manager.prompt())
    Monitor.start()
    Worker.start()
    Repl.start()
  end
end
