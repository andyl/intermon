defmodule Superwatch.MixProject do
  use Mix.Project

  def project do
    [
      app: :superwatch,
      version: "0.0.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :muontrap],
      mod: {Superwatch.Svc.Application, []},
    ]
  end

  defp deps do
    [
      {:muontrap, "~> 1.0"},
      {:yaml_elixir, "~> 2.8"},
      {:file_system, "~> 0.2"},
      {:ymlr, "~> 2.0"},
      {:table_rex, "~> 3.1"}
    ]
  end

  defp aliases do
    [
      repl: ["run -e Superwatch.Cli.Base.start"]
    ]
  end
end
