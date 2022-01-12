defmodule Superwatch.Background.UserStateTest do
  use ExUnit.Case

  alias Superwatch.Background.UserState
  
  setup do 
    srcfile = Application.app_dir(:superwatch) <> "/priv/superwatch_state.yml"
    tgtfile = "/tmp/superwatch_test_state.yml"
    File.cp(srcfile, tgtfile)
  end

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({UserState, %{}}) 
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({UserState, %{}}) 
    end
  end

  describe "prefs/0" do 
    test "returns a map" do 
      start_supervised!({UserState, %{}}) 
      assert UserState.prefs() 
      assert %{} = UserState.prefs()
    end

    test "returns state values" do 
      start_supervised!({UserState, %{}}) 
      assert UserState.prefs().agent == "ex_unit"
    end

    test "init with alt prefs" do 
      start_supervised!({UserState, %{agent: "pong"}}) 
      assert UserState.prefs().agent == "pong"
    end
  end

  describe "set_pref/2" do
    test "update agent" do
      start_supervised!({UserState, %{}}) 
      assert UserState.set_pref(:agent, "pong")
      assert UserState.prefs().agent == "pong"
    end
  end

end
