defmodule Util.MapUtil do

  def atomify_keys(data) when is_list(data) do
    case all_tuples(data) do
      true -> data|> Enum.into(%{}) |> atomify_keys()
      _ -> data |> Enum.map(&atomify_keys/1)
    end
  end

  def atomify_keys({key, val}) do
    %{atomify(key) => val}
  end

  def atomify_keys(data) when is_map(data) do
    Map.new(data, &reduce_keys_to_atoms/1)
  end

  def atomify_keys(data) when is_integer(data) or is_binary(data) or is_atom(data) do
    data
  end

  defp reduce_keys_to_atoms({key, val}) when is_map(val) do
    {atomify(key), atomify_keys(val)}
  end

  defp reduce_keys_to_atoms({key, val}) when is_list(val) do
    {atomify(key), Enum.map(val, &atomify_keys(&1))}
  end

  defp reduce_keys_to_atoms({key, val}) do
    {atomify(key), val}
  end

  defp atomify([string, atom]) when is_binary(string) and is_atom(atom) do
    String.to_atom(string)
  end

  defp atomify(key) when is_binary(key) do
    String.to_atom(key)
  end

  defp atomify(key) do
    key
  end

  defp all_tuples(list) do
    list
    |> Enum.all?(&is_tuple/1)
  end

end
