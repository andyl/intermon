defmodule Superwatch.MixProject do
  use Mix.Project

  def project do
    [
      app: :superwatch,
      version: "0.0.2",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :muontrap, :eex],
      mod: {Superwatch.Svc.App, []},
    ]
  end

  defp deps do
    [
      {:muontrap, "~> 1.1"},
      {:table_rex, "~> 3.1"},
      {:file_system, "~> 0.2"},
      {:yaml_elixir, "~> 2.9"},
      {:ymlr, "~> 3.0"},
    ]
  end

  defp aliases do
    [
      repl: ["run -e Superwatch.Cli.Base.start"]
    ]
  end
end
