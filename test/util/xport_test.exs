defmodule Util.XportTest do

  use ExUnit.Case

  alias Util.Xport

  import ExUnit.CaptureIO

  describe "#call" do

    test "successful call" do
      result = Xport.call("echo HELLO")
      assert result == {:ok, "HELLO\n"}
    end

    test "bad call" do
      result = Xport.call("HELLO")
      assert {:error, :enoent} == result
    end
  end

  describe "#cast" do
    test "successful cast" do
      result = capture_io(fn ->
        Xport.cast("echo HELLO")
      end)
      assert result
    end
  end

end
