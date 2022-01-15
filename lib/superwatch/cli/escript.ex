defmodule Superwatch.Cli.Escript do

  def main([]) do 
    help()
  end

  def main([arg]) do
    case arg do 
      "check" -> check()
      "init"  -> init()
      "start" -> Superwatch.Cli.Repl.start()
      "help"  -> help()
      arg -> IO.puts("Unrecognized: #{arg} (try 'superwatch help')")
    end
  end

  def help do
    IO.puts """
    Superwatch Help
      check  - check for file-watcher dependencies (fswatch etc.)
      init   - create a superwatch config file at ~/.superwatch.yml
      start  - start an agent
      help   - this command
    """
  end

  def check do 
    IO.puts("CHECK")
  end

  def init do 
    IO.puts("INIT")
  end

  def start do 
    cmd = Superwatch.Background.Manager.command()
    Superwatch.Background.Worker.start(cmd)
    Superwatch.Cli.Repl.start()
  end
end
