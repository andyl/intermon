defmodule Superwatch.Sys do

  @moduledoc """
  Contains functions that compute values stored in stateful services.
  """

  def prompt() do
    active_agent = Superwatch.Svc.Store.api_active_agent()
    "|----------\n| agent: #{active_agent} | command: #{command()}\n| Superwatch ('?' for help) > "
  end

  def command do
    active_agent = Superwatch.Svc.Store.api_active_agent()
    Superwatch.Svc.Store.api_merged_data()[active_agent]
    |> command_with_args()
  end

  @doc false
  def command_with_args(merge_data) do
    merge_data
    |> parse_prefs()
    |> gen_assigns(merge_data)
    |> eval_command(merge_data)
    |> String.trim()
  end

  defp parse_prefs(merge_data) do
    merge_data
    |> Map.get(:prefs, "")
    |> OptionParser.split()
    |> OptionParser.parse(strict: parse_opts(merge_data))
    |> elem(0)
  end

  defp parse_opts(merge_data) do
    flags = Map.get(merge_data, :flags, %{}) |> Map.keys() |> Enum.map(&({&1, :boolean}))
    args  = Map.get(merge_data, :args, %{})  |> Map.keys() |> Enum.map(&({&1, :string}))
    flags ++ args
  end

  defp gen_assigns(parse_data, merge_data) do
    flags = gen_flags(parse_data, merge_data)
    args  = gen_args(parse_data, merge_data)
    [flags: flags, args: args]
  end

  defp gen_flags(parse_data, merge_data) do
    flags = Map.get(merge_data, :flags, %{})
    parse_data
    |> Enum.map(fn
      {key, true} -> get_in(flags, [key, :output])
      _ -> nil
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  defp gen_args(parse_data, merge_data) do
    args = Map.get(merge_data, :args, %{})
    parse_data
    |> Enum.map(fn
      {_key, true} -> nil
      {key, val}  -> get_in(args, [key, :output]) |> eval_arg(val)
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  defp eval_command(assigns, merge_data) do
    merge_data[:command] || ""
    |> EEx.eval_string(assigns)
  end

  defp eval_arg(nil, _value) do
    nil
  end

  defp eval_arg(string, value) do
    EEx.eval_string(string, [value: value])
  end

end
