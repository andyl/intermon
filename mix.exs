defmodule Intermon.MixProject do
  use Mix.Project

  def project do
    [
      app: :superwatch,
      version: "0.0.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      escript: escript(), 
      aliases: aliases(), 
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :muontrap],
      mod: {Superwatch.Background.Application, []}, 
    ]
  end

  defp deps do
    [
      {:muontrap, "~> 1.0"}, 
      {:yaml_elixir, "~> 2.8"}, 
      {:file_system, "~> 0.2"}, 
      {:ymlr, "~> 2.0"}
    ]
  end

  defp escript do 
    [
      main_module: Superwatch.Cli.Escript
    ]
  end

  defp aliases do
    [
      repl: ["run -e \"Superwatch.Cli.Escript.start()\""]
    ]
  end
end
