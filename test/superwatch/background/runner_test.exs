defmodule Superwatch.Background.RunnerTest do
  use ExUnit.Case

  alias Superwatch.Background.Runner
  # import ExUnit.CaptureIO

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
    test "returns command value (streamio: false)" do
      start_supervised!({Runner, []})
      Runner.start("echo HELLO")  
      assert Runner.task_await() == "HELLO\n"
      assert Runner.state() 
    end

    test "returns command value (streamio: true)" do
      start_supervised!({Runner, []})
      Runner.set(streamio: true)
      Runner.start("touch /tmp")  
      assert Runner.task_await() == "Stream Output"
      assert Runner.state() 
    end
  end

  describe "start/1 and prompt" do
    test "without streamio" do
      start_supervised!({Runner, []})
      Runner.set(prompt: "bing > ")
      Runner.start("whoami") 
      assert Runner.task_await()
      assert Runner.state()
    end

    test "with streamio" do
      start_supervised!({Runner, []})
      Runner.set(streamio: true, prompt: "")
      Runner.start("touch /tmp") 
      assert Runner.task_await()
      assert Runner.state()
    end
  end

  describe "start/1 and clearscreen" do
    test "without streamio" do
      start_supervised!({Runner, []})
      Runner.set(clearscreen: true)
      Runner.start("whoami") 
      assert Runner.task_await()
      assert Runner.state()
    end

    test "with streamio" do
      start_supervised!({Runner, []})
      Runner.set(streamio: true, clearscreen: false)
      Runner.start("touch /tmp") 
      assert Runner.task_await()
      assert Runner.state()
    end

    test "with streamio and prompt" do
      start_supervised!({Runner, []})
      Runner.set(streamio: true, prompt: "", clearscreen: false)
      Runner.start("touch /tmp") 
      assert Runner.task_await()
      assert Runner.state() 
    end
  end
  
end
