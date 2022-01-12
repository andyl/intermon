defmodule Superwatch.Background.UserConfigTest do
  use ExUnit.Case

  alias Superwatch.Background.UserConfig

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({UserConfig, %{}}) 
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({UserConfig, %{}}) 
    end
  end

  describe "config/0" do
    test "returns a map" do
      start_supervised!({UserConfig, %{}})
      assert UserConfig.config()
      assert UserConfig.config().ex_unit
    end
  end
  
end
