defmodule Superwatch.Sys do

  @moduledoc """
  Contains functions that compute values stored in stateful services.
  """

  def prompt() do
    "Superwatch ('?' for help) > "
  end

  def command do
    active_agent = Superwatch.Svc.Store.api_active_agent()
    cmd = Superwatch.Svc.Store.api_merged_data()[active_agent][:command]
    # wcmd = "mix test --stale --color"
    # wcmd = "mix compile --color"
    # wcmd = ~s(echo ""; echo CHANGE DETECTED; echo ---)
    cmd
  end

end
