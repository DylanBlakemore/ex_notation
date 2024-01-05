defmodule ExNotation.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_notation,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31.0"},
      {:bumpit, "~> 0.1.0"}
    ]
  end

  defp description do
    """
    A library for parsing and evaluating mathematical expressions in Elixir using various notations
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Dylan Blakemore"],
      licenses: ["MIT"],
      links: %{"GitHub" => ""}
    ]
  end
end
