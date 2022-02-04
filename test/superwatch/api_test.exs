defmodule Superwatch.ApiTest do
  use ExUnit.Case

  alias Superwatch.Api
  alias Superwatch.Svc.{Watcher, Worker}
  alias Superwatch.Svc.Store.{Agents, Prefs}

  setup do
    Prefs.setup_test_prefs()
    start_supervised!({Agents, []})
    start_supervised!({Prefs, []})
    start_supervised!({Watcher, []})
    start_supervised!({Worker, []})
    :ok
  end

  describe "services" do
    test "registration" do
      assert Process.whereis(:agents_proc)
      assert Process.whereis(:prefs_proc)
      assert Process.whereis(:monitor_proc)
      assert Process.whereis(:worker_proc)
    end
  end

  describe "agent_list/1" do
    test "returns a value" do
      assert Api.agent_list()
    end
  end

end
