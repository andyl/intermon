defmodule Superwatch.Svc.WorkerTest do

  use ExUnit.Case

  alias Superwatch.Svc.Worker
  import ExUnit.CaptureIO

  describe "GenServer init" do
    test "with start_supervised" do
      assert {:ok, _pid} = start_supervised({Worker, []}) 
    end

    test "with start_supervised!" do
      assert _pid = start_supervised!({Worker, []}) 
    end
  end
  
  describe "state/0" do
    test "returns a map" do
      start_supervised!({Worker, []})
      assert Worker.state() 
      assert Worker.state().prompt == nil
      assert Worker.state().task == nil
      assert Worker.state().cmd == nil
    end
  end

  describe "start/1 and stdout" do
    test "returns command output" do
      assert capture_io(fn -> 
        start_supervised!({Worker, []})
        Worker.start("echo HELLO")  
        Worker.task_await() 
      end) =~ "HELLO"
    end
  end

  describe "start/1 and prompt" do
    test "shows prompt" do
      assert capture_io(fn -> 
        start_supervised!({Worker, []})
        Worker.set(prompt: "bing > ")
        Worker.start("whoami") 
        Worker.task_await()
      end) =~ "bing"
    end
  end

  describe "start/1 and clearscreen" do
    test "clears screen" do
      assert capture_io(fn -> 
        start_supervised!({Worker, []})
        Worker.set(clearscreen: true)
        Worker.start("echo HELLO") 
        Worker.task_await()
      end) =~ "HELLO"
    end

    test "with prompt" do
      assert capture_io(fn -> 
        start_supervised!({Worker, []})
        Worker.set(prompt: "hey > ", clearscreen: true)
        Worker.start("echo HELLO") 
        Worker.task_await()
      end) =~ "hey"
    end
  end
  
end
