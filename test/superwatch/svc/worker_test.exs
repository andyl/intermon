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

    test "registered process name" do
      start_supervised({Worker, []})
      assert Process.whereis(:worker_proc)
      refute Process.whereis(:monitor_proc)
    end
  end

  describe "state/0" do
    test "returns a map" do
      start_supervised!({Worker, []})
      assert Worker.api_state()
      assert Worker.api_state().prompt == nil
      assert Worker.api_state().task == nil
      assert Worker.api_state().cmd == nil
    end
  end

  # TODO: Fix
  describe "start/1 and stdout" do
    test "returns command output" do
      result = capture_io(fn ->
        start_supervised!({Worker, []})
        Worker.api_start("echo HELLO")
        Worker.api_state()
        Worker.api_task_await()
      end)
      result =~ "HELLO"
    end
  end

  describe "start/1 and prompt" do
    test "shows prompt" do
      result = capture_io(fn ->
        start_supervised!({Worker, []})
        Worker.api_set(prompt: "bing > ")
        Worker.api_start("whoami")
        Worker.api_task_await()
      end)
      result =~ "bing"
    end
  end

  describe "start/1 and clearscreen" do
    test "clears screen" do
      result =  capture_io(fn ->
        start_supervised!({Worker, []})
        Worker.api_set(clearscreen: true)
        Worker.api_start("echo HELLO")
        Worker.api_task_await()
      end)
      assert result =~ "\ec"
    end

    test "with prompt" do
      result = capture_io(fn ->
        start_supervised!({Worker, []})
        Worker.api_set(prompt: "hey > ", clearscreen: true)
        Worker.api_start("echo HELLO")
        Worker.api_task_await()
      end)
      assert result =~ "\ec"
    end
  end

end
