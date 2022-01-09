defmodule Superwatch.Config do

  alias Superwatch.Agent

  def user_config_yaml do
    if file_exists?() do 
      user_config_file() |> File.read!()
    else
      ""
    end
  end

  def test_config_yaml do
    test_config_file() |> File.read!()
  end

  def config_data(yaml) do
    yaml 
    |> YamlElixir.read_from_string!()
  end

  def config_struct(data) do
    data 
    |> Enum.map(&Agent.gen/1)
  end

  # -----

  defp test_config_file do
    Application.app_dir(:superwatch) <> "/priv/superwatch.yml"
  end

  defp user_config_file do 
    "~/superchat.yml" |> Path.expand()
  end 

  defp file_exists? do
    user_config_file() |> File.exists?()
  end
end
