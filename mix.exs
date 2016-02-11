defmodule Mojoauth.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mojoauth,
      version: "1.0.2",
      elixir: "~> 1.0",
      deps: deps,
      description: "MojoAuth is a set of standard approaches to cross-app authentication based on HMAC.",
      package: package,
      name: "mojoauth",
      source_url: "https://github.com/adhearsion/mojo-auth.ex",
      homepage_url: "http://mojoauth.mojolingo.com",
      docs: docs,
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :timex]]
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
      {:timex, "~> 1.0"},
      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.6", only: :dev},
      {:mix_test_watch, "~> 0.2", only: :dev},
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      maintainers: ["Ben Langfeld"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/adhearsion/mojo-auth.ex",
        "Docs" => "http://hexdocs.pm/mojoauth/"
      }
    ]
  end

  defp docs do
    [
      readme: true,
      main: "MojoAuth",
    ]
  end

end
