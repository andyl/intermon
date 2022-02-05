defmodule Superwatch.Svc.StoreTest do
  use ExUnit.Case

  alias Superwatch.Svc.Store

  setup do
    Store.setup_test_overlay()
  end

  describe "File management" do
    test "filenames" do
      assert Store.default_root_file()
      assert Store.default_overlay_file()
    end

    test "file presence" do
      assert Store.default_root_file() |> File.exists?()
      assert Store.default_overlay_file() |> File.exists?()
    end

    test "read yaml" do
      assert Store.default_root_file() |> Store.read_yaml()
      assert Store.default_overlay_file() |> Store.read_yaml()
    end

    test "read data" do
      assert Store.default_root_file() |> Store.read_data()
      assert Store.default_overlay_file() |> Store.read_data()
    end
  end

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({Store, []})
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({Store, []})
    end

    test "registered process name" do
      start_supervised({Store, []})
      assert Process.whereis(:store_proc)
    end
  end

  describe "api files and data" do
    test "filenames" do
      start_supervised({Store, []})
      assert Store.api_root_file()
      assert Store.api_overlay_file()
    end

    test "file presence" do
      start_supervised({Store, []})
      assert Store.api_root_file() |> File.exists?()
      assert Store.api_overlay_file() |> File.exists?()
    end

    test "agent data" do
      start_supervised({Store, []})
      assert Store.api_root_data()
      assert Store.api_overlay_data()
    end
  end

  describe "api_merged_data/0" do
    test "merged data" do
      start_supervised({Store, []})
      assert Store.api_merged_data()
    end
  end

  describe "api_active_agent/0" do
    test "returns an atop" do
      start_supervised({Store, []})
      assert Store.api_active_agent()
    end
  end

#   describe "api_config/0" do
#     test "returns a map" do
#       start_supervised!({Agents, []})
#       assert Agents.api_config()
#       assert Agents.api_config().ex_unit
#     end
#   end
#
#   describe "api_find/1" do
#     test "returns the first value" do
#       start_supervised!({Agents, []})
#       {:ok, value} = Agents.api_find(:ex_unit)
#       assert value
#     end
#
#     test "returns the second value" do
#       start_supervised!({Agents, []})
#       {:ok, value} = Agents.api_find(:rspec)
#       assert value
#     end
#
#     test "handles a missing value" do
#       start_supervised!({Agents, []})
#       value = Agents.api_find(:xxxx)
#       assert value == :error
#     end
#   end

end
