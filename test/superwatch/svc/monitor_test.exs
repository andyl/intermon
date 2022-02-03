defmodule Superwatch.Svc.MonitorTest do

  use ExUnit.Case

  alias Superwatch.Svc.Monitor

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({Monitor, []})
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({Monitor, []})
    end

    test "registered process name" do
      start_supervised({Monitor, []})
      assert Process.whereis(:monitor_proc)
      refute Process.whereis(:worker_proc)
    end
  end

  describe "state/0" do
    test "returns a map" do
      start_supervised!({Monitor, []})
      assert Monitor.api_state()
      assert Monitor.api_state().pid == nil
      assert Monitor.api_state().dirs
      assert Monitor.api_state().ftypes
      assert Monitor.api_state().filter == nil
    end
  end

end
