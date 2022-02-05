defmodule Superwatch.Svc.WatcherTest do

  use ExUnit.Case

  alias Superwatch.Svc.Watcher

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({Watcher, []})
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({Watcher, []})
    end

    test "registered process name" do
      start_supervised({Watcher, []})
      assert Process.whereis(:monitor_proc)
      refute Process.whereis(:worker_proc)
    end
  end

  describe "state/0" do
    test "returns a map" do
      start_supervised!({Watcher, []})
      assert Watcher.api_state()
      assert Watcher.api_state().pid == nil
      assert Watcher.api_state().dirs
      assert Watcher.api_state().ftypes
      assert Watcher.api_state().filter == nil
    end
  end

end
