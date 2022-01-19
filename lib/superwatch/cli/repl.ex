defmodule Superwatch.Cli.Repl do

  alias Superwatch.Svc.Worker
  alias Superwatch.Svc.Monitor
  alias Superwatch.Sys

  def start() do
    loop() 
  end

  defp loop do
    result = IO.gets("") |> String.trim()
    case result do 
      "exit"  -> IO.puts("EXITING")
      "xx"    -> IO.puts("EXITING")
      ""      -> Worker.start()           ; loop()
      "state" -> do_state(); do_prompt()  ; loop()
      "reset" -> do_help() ; do_prompt()  ; loop()
      "?"     -> do_help() ; do_prompt()  ; loop()
      value   -> IO.puts("Unrecognized command (#{value})"); do_prompt(); loop()
    end
  end

  defp do_help do
    IO.puts(
      """

      Superwatch Help
        <CR>    - rerun worker 
        state   - show REPL state
        exit    - quit Superwatch
        reset   - reset Agent
        ?       - help (this command)
      """
    )
  end

  defdelegate prompt, to: Sys

  defp do_prompt do 
    prompt() |> IO.write()
  end

  defp do_state do 
    IO.inspect(Worker.state(), label: "WORKER") 
    IO.inspect(Monitor.state(), label: "MONITOR") 
  end
end
