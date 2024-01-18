defmodule Superwatch.MixProject do
  use Mix.Project

  def project do
    [
      app: :superwatch,
      version: "0.0.2",
      elixir: "~> 1.16",
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
      {:muontrap, "~> 1.4"},
      {:table_rex, "~> 4.0"},
      {:file_system, "~> 1.0"},
      {:yaml_elixir, "~> 2.9"},
      {:ymlr, "~> 5.1"},
    ]
  end

  defp aliases do
    [
      repl: ["run -e Superwatch.Cli.Base.start"]
    ]
  end
end
