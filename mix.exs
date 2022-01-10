defmodule Intermon.MixProject do
  use Mix.Project

  def project do
    [
      app: :superwatch,
      version: "0.0.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      escript: escript(), 
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Superwatch.Background.Application, []}
    ]
  end

  defp deps do
    [
      {:yaml_elixir, "~> 2.8"}
    ]
  end

  defp escript do 
    [
      main_module: Superwatch.Cli.Escript
    ]
  end
end
