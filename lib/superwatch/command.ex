defmodule Superwatch.Command do

  def text(_config, state) do 
    wcmd = "mix test --stale --color; echo ---"
    case state.agent do 
      "ex_unit" -> ~s[watchexec -c -w lib -w test -e ex,exs,eex,heex "#{wcmd}"]
      "ex_unit_umbrella" -> ~s[watchexec -c -w apps -e ex,exs,eex,heex "#{wcmd}"]
    end
  end

end
