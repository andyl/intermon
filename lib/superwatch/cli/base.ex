defmodule Superwatch.Cli.Base do

  alias Superwatch.Background.Worker
  alias Superwatch.Cli.Repl

  def main([]) do 
    help()
  end

  def main([arg]) do
    case arg do 
      "init"  -> init()
      "start" -> Superwatch.Cli.Repl.start()
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
    cmd = Superwatch.Background.Manager.command()
    Worker.set(cmd: cmd, prompt: "Superwatch > ", clearscreen: true)
    Worker.start()
    Repl.start()
  end
end
