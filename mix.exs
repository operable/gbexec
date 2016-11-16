defmodule GreenbarExec.Mixfile do
  use Mix.Project

  def project do
    [app: :greenbar_exec,
     version: "1.0.0",
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

  defp deps do
    [{:greenbar, github: "operable/greenbar"},
     {:template_processors, github: "operable/template_processors"}]
  end

  defp escript() do
    [main_module: GreenbarExec,
     path: "bin/gbexec"]
  end
end
