defmodule Superwatch.AgentTest do
  use ExUnit.Case

  alias Superwatch.Data.Agent

  describe "gen/1" do
    test "basic operation" do
      msg = "HELLO"
      input = %{desc: msg}
      output = Agent.gen(input)
      assert %Agent{} = output
      assert output.desc == msg
    end

    test "non-standard keys" do
      msg = "HELLO"
      input = %{description: msg}
      output = Agent.gen(input)
      assert %Agent{} = output
      assert is_struct(output)
      assert output.desc == nil
    end
  end

  describe "to_map/1" do
    test "basic operation" do
      msg = "HELLO"
      input = %Agent{desc: msg}
      output = Agent.to_map(input)
      assert is_map(output)
      refute is_struct(output)
      assert output.desc == msg
    end
  end

  describe "strip/1" do
    test "basic operation" do
      msg = "HELLO"
      input = %Agent{desc: msg}
      output = Agent.strip(input)
      assert is_map(output)
      assert output |> Map.has_key?(:desc)
      refute output |> Map.has_key?(:worker_cmd)
    end
  end

  describe "merge/2" do
    test "basic operation" do
      agent1 = %Agent{ desc: "HI" }
      agent2 = %Agent{ worker_cmd: "whoami" }
      agent3 = Agent.merge(agent1, agent2)
      assert %Agent{} = agent3
      assert agent3.desc
      assert agent3.worker_cmd
      refute agent3.worker_flags
    end

    test "overlap values" do
      agent1 = %Agent{ desc: "HI" }
      agent2 = %Agent{ desc: "BYE", worker_cmd: "whoami" }
      agent3 = Agent.merge(agent1, agent2)
      assert %Agent{} = agent3
      assert agent3.desc == "BYE"
    end
  end

end
