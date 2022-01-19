defmodule Superwatch.ArgTest do
  use ExUnit.Case

  # alias Superwatch.Arg

  # describe "#gen" do
  #   test "with complete map" do 
  #     opt = opt_map() |> Arg.gen() 
  #     assert opt
  #   end
  # end
  #
  # describe "#set" do
  #   test "with input value" do 
  #     opt1 = opt_map() |> Arg.gen() 
  #     refute opt1.value
  #     opt2 = opt1 |> Arg.set("asdf")
  #     assert opt2.value == "asdf"
  #   end
  # end
  #
  # describe "#clear" do
  #   test "with input value" do 
  #     opt1 = opt_map() |> Arg.gen() 
  #     refute opt1.value
  #     opt2 = opt1 |> Arg.set("asdf")
  #     assert opt2.value == "asdf"
  #     opt3 = opt2 |> Arg.clear()
  #     refute opt3.value 
  #   end
  # end
  #
  # defp opt_map do
  #   opt = Superwatch.Config.test_yaml()
  #          |> Superwatch.Config.config_data()
  #          |> Map.fetch!("ex_unit") 
  #          |> Map.fetch!("worker_opts") 
  #          |> Map.fetch!("only")
  #   {"only", opt}
  # end

end
