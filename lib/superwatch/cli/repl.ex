defmodule Superwatch.Cli.Repl do
  def start() do
    loop() 
  end

  defdelegate prompt, to: Superwatch.Background.Manager

  defp loop do
    IO.write("L | " <> prompt()) 
    result = IO.gets("") |> String.trim()
    case result do 
      "exit"  -> IO.puts("EXITING")
      "xx"    -> IO.puts("EXITING")
      "reset" -> help(); loop()
      "?"     -> help(); loop()
      value   -> IO.puts("Unrecognized command (#{value})"); loop()
    end
  end

  defp help do
    IO.puts(
      """

      Superwatch Help
        exit  - quit Superwatch
        reset - reset Agent
        ?     - help (this command)
      """
    )
  end
end
