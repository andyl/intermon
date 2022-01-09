defmodule Superwatch.ConfigTest do
  use ExUnit.Case

  alias Superwatch.Config

  describe "#user_config_yaml" do 
    test "returns a string" do 
      result = Config.user_config_yaml()
      assert result
    end
  end
  
  describe "#test_config_yaml" do 
    test "returns a string" do 
      result = Config.test_config_yaml()
      assert result
    end
  end

  describe "#config_data" do
    test "has agents" do
      data = Config.test_config_yaml() |> Config.config_data()
      assert data 
      assert data |> Map.keys() == ~w(ex_unit ex_unit_umbrella)
    end
  end

  describe "#config_struct" do
    test "generates struct for each agent" do 
      list = Config.test_config_yaml() |> Config.config_data() |> Config.config_struct()
      assert list |> IO.inspect()
    end
  end
end
