defmodule Mojoauth.Mixfile do
  use Mix.Project

  def project do
    [app: :mojoauth,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps,
     description: "MojoAuth is a set of standard approaches to cross-app authentication based on HMAC.",
     package: package,
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
    [{:timex, "~> 0.12.9"}]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      contributors: ["Ben Langfeld"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/mojolingo/mojo-auth.ex",
        "Docs" => "http://mojolingo.github.io/mojo-auth.ex"
      }
    ]
  end
end
