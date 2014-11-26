defmodule Mojoauth.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mojoauth,
      version: "0.1.0",
      elixir: "~> 1.0.0",
      deps: deps,
      description: "MojoAuth is a set of standard approaches to cross-app authentication based on HMAC.",
      package: package,
      name: "mojoauth",
      source_url: "https://github.com/mojolingo/mojo-auth.ex",
      homepage_url: "http://mojoauth.mojolingo.com",
      docs: docs,
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:timex, "~> 0.12.9"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.6", only: :dev},
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      contributors: ["Ben Langfeld"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/mojolingo/mojo-auth.ex",
        "Docs" => "http://hexdocs.pm/mojoauth/"
      }
    ]
  end

  defp docs do
    [
      readme: true,
      main: "readme",
    ]
  end

end
