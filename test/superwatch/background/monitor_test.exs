defmodule Superwatch.Background.MonitorTest do

  use ExUnit.Case

  alias Superwatch.Background.Monitor

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({Monitor, []}) 
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({Monitor, []}) 
    end
  end

  describe "state/0" do
    test "returns a map" do
      start_supervised!({Monitor, []})
      assert Monitor.state() 
      assert Monitor.state().pid == nil
      assert Monitor.state().dirs 
      assert Monitor.state().ftypes 
      assert Monitor.state().filter == nil
    end
  end
  
end
