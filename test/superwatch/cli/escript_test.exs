defmodule Superwatch.Cli.EscriptTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Superwatch.Cli.Escript

  describe "#main" do
    test "with no args" do
      assert capture_io(fn -> Escript.main([]) end) =~ "Superwatch Help"
    end

    test "with unknown args" do 
      assert capture_io(fn -> Escript.main(~w(asdf)) end) =~ "Unrecognized"
    end

    test "with help arg" do 
      assert capture_io(fn -> Escript.main(~w(help)) end) =~ "Superwatch Help"
    end

    test "with init arg" do 
      assert capture_io(fn -> Escript.main(~w(init)) end) =~ "INIT"
    end
  end

  describe "#help" do
    test "generates a string" do
      assert capture_io(fn -> Escript.help() end) =~ "Superwatch Help"
    end
  end

end
