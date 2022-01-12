defmodule Superwatch.Cli.Escript do

  alias Superwatch.{Config, State} 

  def main([]) do 
    help()
  end

  def main([arg]) do
    case arg do 
      "check" -> check()
      "init"  -> init()
      "start" -> start()
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
    config = Config.test_struct() 
    state  = State.struct(:test) 
    cmd = Superwatch.Command.text(config, state)
    Superwatch.Background.Worker.start(cmd)
    Superwatch.Cli.Repl.start(config, state)
  end
end
