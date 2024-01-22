defmodule Util.Xport do
  @moduledoc """
  Utilities for launching external programs using Elixir ports.

  Intended f
  or Elixir scripts and CLI apps.
  """

  @doc """
  Launch an editor.

  icmd is a single string, command plus argments separated by spaces
  """
  def editor(icmd) do
    port = Port.open({:spawn, icmd}, [:nouse_stdio, :exit_status])

    receive do
      {^port, {:exit_status, exit_status}} -> IO.puts("exited with #{exit_status}")
    end
  end

  @doc """
  Call a synchronous external command, and get the return value.
  """
  def call(icmd) do
    [cmd | args] = icmd |> OptionParser.split()

    try do
      case System.cmd(cmd, args) do
        {result, 0} -> {:ok, result}
        {result, _} -> {:error, result}
      end
    catch
      :exit, reason -> {:error, reason}
      :error, reason -> {:error, reason}
    end
  end

  @doc """
  Call an asynchronous external command, and get the return value.

  Especially useful for long-running comands = eg "ping -i 5 localhost"
  """
  def cast(icmd) do
    IO.inspect(icmd, label: "LABELZZ")
    [cmd | args] = icmd |> OptionParser.split()
    Task.async(fn ->
      MuonTrap.cmd(cmd, args, into: IO.stream())
    end)
  end

  def alive?(task) do
    task.pid
    |> Process.alive?()
  end

  def await(task) do
    Task.await(task)
  end

  def kill(task) do
    task |> Task.shutdown()
  end
end
