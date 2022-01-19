defmodule Superwatch.User.ConfigTest do
  use ExUnit.Case

  alias Superwatch.User.Config

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({Config, %{}}) 
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({Config, %{}}) 
    end
  end

  describe "config/0" do
    test "returns a map" do
      start_supervised!({Config, %{}})
      assert Config.config() 
      assert Config.config().ex_unit
    end
  end
  
end
