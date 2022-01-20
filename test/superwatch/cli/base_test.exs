defmodule Superwatch.Cli.BaseTest do

  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Superwatch.Cli.Base

  describe "#main" do
    test "with no args" do
      assert capture_io(fn -> Base.main([]) end) =~ "Superwatch Help"
    end

    test "with unknown args" do 
      assert capture_io(fn -> Base.main(~w(asdf)) end) =~ "Unrecognized"
    end

    test "with help arg" do 
      assert capture_io(fn -> Base.main(~w(help)) end) =~ "Superwatch Help"
    end
  end

  describe "#help" do
    test "generates a string" do
      assert capture_io(fn -> Base.help() end) =~ "Superwatch Help"
    end
  end

end
