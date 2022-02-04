defmodule Superwatch.Svc.Store.AgentsTest do
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

  describe "api_config/0" do
    test "returns a map" do
      start_supervised!({Agents, []})
      assert Agents.api_config()
      assert Agents.api_config().ex_unit
    end
  end

  describe "api_find/1" do
    test "returns the first value" do
      start_supervised!({Agents, []})
      {:ok, value} = Agents.api_find(:ex_unit)
      assert value
    end

    test "returns the second value" do
      start_supervised!({Agents, []})
      {:ok, value} = Agents.api_find(:rspec)
      assert value
    end

    test "handles a missing value" do
      start_supervised!({Agents, []})
      value = Agents.api_find(:xxxx)
      assert value == :error
    end
  end

end
