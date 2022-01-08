defmodule IntermonTest do
  use ExUnit.Case
  doctest Intermon

  test "greets the world" do
    assert Intermon.hello() == :world
  end
end
