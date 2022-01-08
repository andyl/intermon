defmodule SuperwatchTest do
  use ExUnit.Case
  doctest Superwatch

  test "greets the world" do
    assert Superwatch.hello() == :world
  end
end
