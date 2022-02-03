defmodule Superwatch.Svc.User.PrefsTest do
  use ExUnit.Case

  alias Superwatch.Svc.User.Prefs

  setup do
    Prefs.setup_test_prefs()
  end

  describe "prefs setup" do
    test "test_prefs/0" do
      assert Prefs.test_prefs()
    end

    test "state_file" do
      assert Prefs.state_file() == Prefs.test_prefs()

    end

    test "read_yaml" do
      assert Prefs.read_yaml()
    end

    test "read_data" do
      assert Prefs.read_data()
    end
  end

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({Prefs, []})
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({Prefs, []})
    end

    test "registered process name" do
      start_supervised({Prefs, []})
      assert Process.whereis(:prefs_proc)
    end
  end

  describe "prefs/0" do
    test "returns a map" do
      start_supervised!({Prefs, []})
      assert Prefs.api_prefs()
      assert %{} = Prefs.api_prefs()
    end

    test "returns state values" do
      start_supervised!({Prefs, []})
      assert Prefs.api_prefs().agent == "ex_unit"
    end

    test "init with alt prefs" do
      start_supervised!({Prefs, [agent: "pong"]})
      assert Prefs.api_prefs().agent == "pong"
    end
  end

  # describe "set_pref/2" do
  #   test "update agent" do
  #     start_supervised!({Prefs, []})
  #     assert Prefs.api_set_prefs(agent: "pong")
  #     assert Prefs.api_prefs().agent == "pong"
  #   end
  # end

end
