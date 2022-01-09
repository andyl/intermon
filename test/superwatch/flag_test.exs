defmodule Superwatch.FlagTest do
  use ExUnit.Case

  alias Superwatch.Flag

  describe "#gen" do
    test "with complete map" do 
      flag = flag_map() |> Flag.gen() 
      assert flag
    end
  end

  describe "#toggle" do
    test "with complete map" do 
      flag1 = flag_map() |> Flag.gen() 
      refute flag1.value
      flag2 = flag1 |> Flag.toggle()
      assert flag2.value
      flag3 = flag2 |> Flag.toggle()
      refute flag3.value
    end
  end

  describe "#make_true" do
    test "with false value" do 
      flag1 = flag_map() |> Flag.gen() 
      refute flag1.value
      flag2 = flag1 |> Flag.make_true()
      assert flag2.value
    end

    test "with true value" do 
      flag1 = flag_map() |> Flag.gen() 
      refute flag1.value
      flag2 = flag1 |> Flag.make_true()
      assert flag2.value
      flag3 = flag2 |> Flag.make_true()
      assert flag3.value
    end
  end

  describe "#make_false" do
    test "with false value" do 
      flag1 = flag_map() |> Flag.gen() 
      refute flag1.value
      flag2 = flag1 |> Flag.make_false()
      refute flag2.value
    end

    test "with true value" do 
      flag1 = flag_map() |> Flag.gen() 
      refute flag1.value
      flag2 = flag1 |> Flag.make_true()
      assert flag2.value
      flag3 = flag2 |> Flag.make_false()
      refute flag3.value
    end
  end

  defp flag_map do
    flag = Superwatch.Config.test_config_yaml()
           |> Superwatch.Config.config_data()
           |> Map.fetch!("ex_unit") 
           |> Map.fetch!("worker_flags") 
           |> Map.fetch!("focus")
    {"focus", flag}
  end

end
