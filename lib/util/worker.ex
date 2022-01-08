defmodule Util.Worker do
  def run(cmd) do
    port = Port.open({:spawn, cmd}, [:stderr_to_stdout, :binary, :exit_status])
    stream_output(port)
  end

  defp stream_output(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write data
        stream_output(port)
      {^port, {:exit_status, 0}} ->
        IO.puts("DONE")
      {^port, {:exit_status, status}} ->
        IO.puts("ERROR -> status #{status}")
    end
  end

end
