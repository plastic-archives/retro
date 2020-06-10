defmodule Retro.MixProject do
  use Mix.Project

  @version "0.2.0"
  @github_url "https://github.com/c4710n/retro"

  def project do
    [
      app: :retro,
      description: "A toolkit for pragmatic programmers.",
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      aliases: aliases(),

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
      {:phoenix, ">= 0.0.0"},
      {:plug, ">= 0.0.0"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{GitHub: @github_url}
    ]
  end

  defp aliases do
    [publish: ["hex.publish", "tag"], tag: &tag_release/1]
  end

  defp tag_release(_) do
    Mix.shell().info("Tagging release as #{@version}")
    System.cmd("git", ["tag", "#{@version}"])
    System.cmd("git", ["push", "--tags"])
  end
end
