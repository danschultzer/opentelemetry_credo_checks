defmodule OpentelemetryCredoChecks.MixProject do
  use Mix.Project

  @source_url "https://github.com/open-telemtrex/opentelemetry_credo_checks"
  @version "0.1.0"

  def project do
    [
      app: :opentelemetry_credo_checks,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      description: "Opentelemetry Credo checks",
      package: package(),

      # Docs
      name: "OpentelemetryCredoChecks",
      docs: docs(),

      # Dialyzer
      dialyzer: [
        plt_add_apps: [:mix]
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
      {:credo, "~> 1.7"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["opentelemetrex", "Dan Schultzer"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Sponsor" => "https://github.com/sponsors/danschultzer"
      },
      files: ~w(lib LICENSE mix.exs README.md)
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "README",
      canonical: "http://hexdocs.pm/opentelemetry_credo_checks",
      source_url: @source_url,
      extras: [
        "README.md": [filename: "README"],
        "CHANGELOG.md": [filename: "CHANGELOG"]
      ],
      skip_undefined_reference_warnings_on: [
        "CHANGELOG.md"
      ]
    ]
  end
end
