defmodule Superwatch.Api do

  @moduledoc """
  Main API for data interaction.

  Called by the CLI.
  """

  alias Superwatch.Svc.{Store, Watcher, Worker}
  alias Superwatch.Sys

  # -- ORG

  def start do
    Store.api_start()
    Watcher.api_start()
    Worker.api_start()
    cmd = Sys.command()
    prompt = Sys.prompt()
    Worker.api_set(cmd: cmd, clearscreen: true, prompt: prompt)
  end

  def stop do
    Store.api_stop()
    Worker.api_stop()
    Watcher.api_stop()
  end

  def kill do
    Store.api_kill()
    Worker.api_kill()
    Watcher.api_kill()
  end


  # -- RUN

  def run do
    Worker.api_start()
  end

  # -- AGENT

  def agent_show do
    active_agent = Superwatch.Svc.Store.api_active_agent()
    active_data = Superwatch.Svc.Store.api_merged_data()[active_agent]
    {active_agent, active_data}
  end

  def agent_list do
    Store.api_merged_data()
    |> Enum.map(fn({name, val}) -> [name, val[:desc], val[:active?]] end)
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
    Store.api_overlay_data()
  end

  # -- SET

  def set(opts) when is_list(opts) do
    # Prefs.api_set_prefs(opts)
    # Watcher.api_set(opts)
    # Worker.api_set(opts)
    :ok
  end

  # -- RELOAD

  def reload do
    Store.api_reload()
    cmd = Sys.command()
    prompt = Sys.prompt()
    Worker.api_set(cmd: cmd, prompt: prompt)
    :ok
  end

end
