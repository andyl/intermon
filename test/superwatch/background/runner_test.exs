defmodule Superwatch.Background.RunnerTest do

  use ExUnit.Case

  alias Superwatch.Background.Runner
  import ExUnit.CaptureIO

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({Runner, []}) 
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({Runner, []}) 
    end
  end
  
  describe "state/0" do
    test "returns a map" do
      start_supervised!({Runner, []})
      assert Runner.state() 
      assert Runner.state().prompt == nil
      assert Runner.state().task == nil
      assert Runner.state().cmd == nil
    end
  end

  describe "start/1 and stdout" do
    test "returns command output" do
      assert capture_io(fn -> 
        start_supervised!({Runner, []})
        Runner.start("echo HELLO")  
        Runner.task_await() 
      end) =~ "HELLO"
    end
  end

  describe "start/1 and prompt" do
    test "shows prompt" do
      assert capture_io(fn -> 
        start_supervised!({Runner, []})
        Runner.set(prompt: "bing > ")
        Runner.start("whoami") 
        Runner.task_await()
      end) =~ "bing"
    end
  end

  describe "start/1 and clearscreen" do
    test "clears screen" do
      assert capture_io(fn -> 
        start_supervised!({Runner, []})
        Runner.set(clearscreen: true)
        Runner.start("echo HELLO") 
        Runner.task_await()
      end) =~ "HELLO"
    end

    test "with prompt" do
      assert capture_io(fn -> 
        start_supervised!({Runner, []})
        Runner.set(prompt: "hey > ", clearscreen: true)
        Runner.start("echo HELLO") 
        Runner.task_await()
      end) =~ "hey"
    end
  end
  
end
