defmodule Superwatch.Api do

  @moduledoc """
  Main API for data interaction.

  Called by the CLI.
  """

  alias Superwatch.Svc.User.{Agents, Prefs}
  alias Superwatch.Svc.{Monitor, Worker}
  alias Superwatch.Sys

  # -- ORG

  def start do
    cmd = Sys.command()
    prompt = Sys.prompt()
    Prefs.api_start()
    Worker.api_set(cmd: cmd, clearscreen: true, prompt: prompt)
    Monitor.api_start()
    Worker.api_start()
  end

  # -- RUN

  def run do
    Worker.api_start()
  end

  # -- AGENT

  def agent_list do
    Agents.api_config()
    |> Enum.map(fn({name, val}) -> [name, val[:desc]] end)
  end

  def agent_select do
    Prefs.api_prefs()
  end

  # -- PREFS

  def prefs do
    Prefs.api_prefs()
  end

  # -- SET

  def set(opts) when is_list(opts) do
    Prefs.api_set_prefs(opts)
    Monitor.api_set(opts)
    Worker.api_set(opts)
  end

  # -- RESET

  def reset do
    Prefs.api_reset()
  end

end
