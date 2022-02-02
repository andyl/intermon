defmodule Superwatch.Sys do

  @moduledoc """
  Contains functions that compute values stored in stateful services.
  """

  def prompt() do
    "Superwatch ('?' for help) > "
  end

    # TODO: read from config, and validate
  def command do
    wcmd = "mix test --stale --color"
    # wcmd = "mix compile --color"
    # wcmd = ~s(echo ""; echo CHANGE DETECTED; echo ---)
    wcmd
  end

end
