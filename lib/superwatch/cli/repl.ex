defmodule Superwatch.Cli.Repl do
  def start(_config, _state) do
    loop() 
  end

  def prompt do
    "Superwatch Repl ('?' for help) > "
  end

  defp loop do
    result = prompt() |> IO.gets() |> String.trim()
    case result do 
      "exit" -> IO.puts("EXITING")
      "xx"   -> IO.puts("EXITING")
      "?"    -> help(); loop()
      value  -> IO.puts("Unrecognized command (#{value})"); loop()
    end
  end

  defp help do
    IO.puts(
      """

      Superwatch Repl Help
        exit - quit Superwatch
        ?    - help (this command)
      """
    )
  end
end
