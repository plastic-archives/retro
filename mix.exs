defmodule Retro.MixProject do
  use Mix.Project

  @github_url "https://github.com/c4710n/retro"

  def project do
    [
      app: :retro,
      description: "A toolkit for pragmatic programmers.",
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # Docs
      name: "Retro",
      source_url: @github_url,
      homepage_url: @github_url,
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tzdata, "~> 1.0.3"},
      {:phoenix_html, ">= 0.0.0"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url}
    ]
  end
end
