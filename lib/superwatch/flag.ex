defmodule Superwatch.Flag do

  alias Superwatch.Flag 

  defstruct [:name, :shortname, :shortdoc, :doc, :output, :value]

  def gen({name, data}) do
    gen(name, data)
  end

  def gen(name, data) do 
    %Flag{
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

  def toggle(old) do
    case old.value do 
      true -> %Flag{old | value: false}
      false -> %Flag{old | value: true}
      nil -> %Flag{old | value: true}
      _ -> %Flag{old | value: true}
    end
  end

  def make_true(old) do 
    %Flag{old | value: true}
  end

  def make_false(old) do 
    %Flag{old | value: false}
  end
  
end
