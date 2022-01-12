defmodule Util.MapUtilTest do

  use ExUnit.Case 

  alias Util.MapUtil 

  test "flat map" do
    old = %{"a" => 1, :b => 2}
    new = %{a: 1, b: 2}
    assert MapUtil.atomify_keys(old) == new
  end

  test "nested map" do
    old = %{"a" => 1, :b => 2, "c" => %{"a" => 1}}
    new = %{a: 1, b: 2, c: %{a: 1}}
    assert MapUtil.atomify_keys(old) == new
  end

  test "with list of int" do
    old = %{"a" => 1, :b => 2, "c" => %{"a" => [1, 2, 3]}}
    new = %{a: 1, b: 2, c: %{a: [1, 2, 3]}}
    assert MapUtil.atomify_keys(old) == new
  end

  test "with mixed list" do
    old = %{"a" => 1, :b => 2, "c" => %{"a" => [1, "asdf", :xxx]}}
    new = %{a: 1, b: 2, c: %{a: [1, "asdf", :xxx]}}
    assert MapUtil.atomify_keys(old) == new
  end

  test "utf8" do
    old = %{"a" => 1, :b => 2, "c" => %{"a" => ["asdf", :utf8 ]}}
    new = %{a: 1, b: 2, c: %{a: ["asdf", :utf8]}}
    assert MapUtil.atomify_keys(old) == new
  end

  test "failure case" do 
    old = %{
      "ex_unit" => %{
        "desc" => "ExUnit for Elixir Project",
        "monitor_command" => "watchexec -c -w lib -w test -e ex,exs,eex,heex \"<%= worker_command %>\"",
        "worker_command" => "mix test <%= worker_flags %> <%= worker_opts %> --stale ; echo ---",
        "worker_exit" => "/^---$/",
        "worker_flags" => %{
          "focus" => %{
            "default" => false,
            "doc" => "Only run specific tests, using ExUnit's `tag` feature\n\n    @tag focus\n    test \"mytest\" do \n      assert 1 == 1\n    end\n",
            "output" => "--only focus:true",
            "shortdoc" => "Run only focus tests",
            "shortname" => "f"
          }
        },
        "worker_opts" => %{
          "only" => %{
            "default" => false,
            "output" => "--only <%= value %>",
            "shortdoc" => "Only run tests that match the filter",
            "shortname" => "o"
          }
        }
      },
      "ex_unit_umbrella" => %{
        "desc" => "ExUnit for Elixir Umbrella Project",
        "include" => ["ex_unit"],
        "monitor_command" => "watchexec -c -w apps -e ex,exs,eex,heex \"<%= worker_command %>\""
      }
    }
    assert MapUtil.atomify_keys(old) 
  end


  end
