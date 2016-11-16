defmodule Mix.Tasks.Escript.Package do

  use Mix.Task

  @shortdoc "Build an escript and package it for distribution"

  def run(args) do
    shared_lib_path = ensure_deps_are_compiled(args)
    Mix.Tasks.Escript.Build.run(args)
    File.cp!(shared_lib_path, "bin/greenbar_markdown.so")
  end

  defp ensure_deps_are_compiled(args) do
    case Path.wildcard("deps/**/priv/greenbar_markdown.so") do
      [] ->
        Mix.Tasks.Deps.Compile.run(args)
        Path.wildcard("deps/**/priv/greenbar_markdown.so")
      shared_lib_path ->
        shared_lib_path
    end
  end

end
