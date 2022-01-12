defmodule Superwatch.Opt do

  alias Superwatch.Opt

  defstruct [:name, :shortname, :shortdoc, :doc, :output, :value]

  def gen({name, data}) do
    gen(name, data)
  end

  def gen(name, data) do 
    %Opt{
      name: name, 
      shortname: Map.get(data, "shortname", ""), 
      shortdoc: Map.get(data, "shortdoc", ""), 
      doc: Map.get(data, "doc", ""), 
      output: Map.get(data, "output", ""), 
    }
  end

  def genmap("") do 
    []
  end

  def genmap(data) when is_map(data) do
    data 
    |> Enum.map(&gen/1)
  end

  def genmap(_map) do 
    []
  end

  def set(old, value) do 
    %Opt{old | value: value}
  end

  def clear(old) do 
    %Opt{old | value: nil}
  end
  
end
