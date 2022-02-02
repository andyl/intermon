defmodule Superwatch.Org do

  @moduledoc """
  Main API for the system.
  """

  alias Superwatch.Sys
  alias Superwatch.Svc.Worker
  alias Superwatch.Svc.Monitor

  def start do
    cmd = Sys.command()
    Worker.set(cmd: cmd, clearscreen: true, prompt: Sys.prompt())
    Monitor.start()
    Worker.start()
  end

end
