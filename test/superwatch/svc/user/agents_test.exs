defmodule Superwatch.Svc.User.AgentsTest do
  use ExUnit.Case

  alias Superwatch.Svc.User.Agents

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({Agents, []})
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({Agents, []})
    end

    test "registered process name" do
      start_supervised({Agents, []})
      assert Process.whereis(:agents_proc)
    end
  end

  describe "config/0" do
    test "returns a map" do
      start_supervised!({Agents, []})
      assert Agents.api_config()
      assert Agents.api_config().ex_unit
    end
  end

end
