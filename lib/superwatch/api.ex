defmodule Superwatch.Api do

  @moduledoc """
  Main API for data interaction.

  Called by the CLI.
  """

  alias Superwatch.Svc.{Store, Watcher, Worker}
  alias Superwatch.Sys

  # -- ORG

  def start do
    cmd = Sys.command()
    prompt = Sys.prompt()
    Store.api_start()
    Worker.api_set(cmd: cmd, clearscreen: true, prompt: prompt)
    Watcher.api_start()
    Worker.api_start()
  end

  # -- RUN

  def run do
    Worker.api_start()
  end

  # -- AGENT

  def agent_list do
    # Agents.api_config()
    # |> Enum.map(fn({name, val}) -> [name, val[:desc]] end)
    :ok
  end

  def agent_select(_target) do
    # with {:ok, agent} <- Agents.api_find(target),
    #      {:ok, pref} <- Prefs.api_select(target, agent)
    # do
    #   {:ok, pref}
    # else
    #   _ -> {:error, "Not found (#{target})"}
    # end
    :ok
  end

  # -- PREFS

  def prefs_show do
    # Prefs.api_prefs()
    :ok
  end

  # -- SET

  def set(opts) when is_list(opts) do
    # Prefs.api_set_prefs(opts)
    # Watcher.api_set(opts)
    # Worker.api_set(opts)
    :ok
  end

  # -- RESET

  def reset do
    # Prefs.api_reset()
    :ok
  end

end
