defmodule Meilisearch.MixProject do
  use Mix.Project

  @version "0.1.0-beta"
  @github_url "https://github.com/robottokauf3/meilisearch-elixir"

  def project do
    [
      app: :meilisearch,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.details": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: dialyzer(),
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev]},
      {:excoveralls, "~> 0.10.0", only: [:test]},
      {:ex_doc, "~> 0.21", only: [:dev], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description() do
    """
    Lightweight Elixir client for MeiliSearch search engine.
    """
  end

  defp package() do
    [
      files: [],
      maintainers: ["Rob Kaufmann"],
      licenses: ["MIT"],
      links: %{
        "Github" => @github_url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      name: "MeiliSearch",
      source_ref: "v#{@version}",
      source_url: @github_url,
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end
end
