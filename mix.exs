defmodule GreenbarExec.Mixfile do
  use Mix.Project

  def project do
    [app: :greenbar_exec,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_options: [warnings_as_errors: System.get_env("ALLOW_WARNINGS") == nil],
     escript: escript(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger,
                    :template_processors,
                    :greenbar_markdown,
                    :greenbar]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:greenbar, github: "operable/greenbar"},
     {:template_processors, github: "operable/template_processors"}]
  end

  defp escript() do
    [main_module: GreenbarExec,
     name: "gbexec"]
  end
end
