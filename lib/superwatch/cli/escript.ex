defmodule Superwatch.Cli.Escript do
  def main([]) do 
    help()
  end

  def main([arg]) do
    case arg do 
      "check" -> IO.puts("check")
      "init"  -> IO.puts("init")
      "start" -> IO.puts("start")
      "help"  -> help()
      arg -> IO.puts("Unrecognized: #{arg}")
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

  def start do 
    # read state 
    # read config
    # select agent
    # start watcher 
    # start repl
  end
end
