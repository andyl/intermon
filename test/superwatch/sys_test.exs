defmodule Superwatch.SysTest do
  use ExUnit.Case

  alias Superwatch.Svc.Store
  alias Superwatch.Sys

  setup do
    Store.setup_test_overlay()
    start_supervised({Store, []})
    :ok
  end

  describe "#prompt/0" do
    test "returns a result" do
      assert Sys.prompt()
    end
  end

  describe "#command/0" do
    test "runs" do
      assert Sys.command()
    end

    test "runs without overlay" do
      File.rm(Store.test_overlay_file())
      Store.api_kill()
      Store.api_start()
      assert Sys.command()
    end
  end

  describe "#command_with_args/0" do
    test "runs" do
      agent = %{ command: "mix test <%= flags %> <%= args %>" }
      assert Sys.command_with_args(agent)
    end

    test "runs with flag" do
      cmdst = "mix test <%= flags %>"
      flags = %{ focus: %{shortname: "f", output: "--only focus: true"}}
      prefs = "--focus"
      agent = %{ command: cmdst, flags: flags, prefs: prefs}
      assert Sys.command_with_args(agent)
    end

    test "runs with arg" do
      cmdst = "mix test <%= args %>"
      args  = %{ only: %{shortname: "o", output: "--only <%= value %>"}}
      prefs = "--only asdf"
      agent = %{ command: cmdst, args: args, prefs: prefs}
      assert Sys.command_with_args(agent)
    end
  end

end
