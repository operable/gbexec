defmodule GreenbarExec do

  alias Greenbar.Engine
  alias GreenbarExec.Options

  defstruct [:template_file, :data_file]

  @script_name "gbexec"
  @options [strict: [slack: :boolean, hipchat: :boolean, help: :boolean],
            aliases: [s: :slack, h: :hipchat]]

  def main(args) do
    {options, args, _} = OptionParser.parse(args, @options)
    if valid_invocation?(options, args) == false do
      display_help
      :init.stop(1)
    else
      if Keyword.get(options, :help, false) do
        display_help()
        :init.stop(0)
      else
        render(options, prepare_args(args))
      end
    end
  end

  defp valid_invocation?(options, args) do
    Enum.empty?(options) == false and Enum.empty?(args) == false
  end

  defp prepare_args([template_file]) do
    %__MODULE__{template_file: template_file}
  end
  defp prepare_args([template_file, data_file]) do
    %__MODULE__{template_file: template_file, data_file: data_file}
  end

  defp render(options, sources) do
    case Options.which_processor?(options) do
      :none ->
        display_help()
        :init.stop(2)
      processor ->
        case read_file(sources.template_file) do
          {:ok, template} ->
            case read_data(sources.data_file) do
              {:ok, data} ->
                case render_template(template, data) do
                  {:ok, directives} ->
                    case processor.render(directives) do
                      {output, attachment} ->
                        display_results(output, attachment)
                      output when is_binary(output) ->
                        display_results(output, nil)
                    end
                  error ->
                    IO.puts :stderr, "Template rendering failed: #{inspect error}"
                    :init.stop(3)
                end
              error ->
                IO.puts :stderr, "Reading template data failed: #{inspect error}"
                :init.stop(4)
            end
          error ->
            IO.puts :stderr, "Reading template source failed: #{inspect error}"
        end
    end
  end

  defp display_results(output, attachment) do
    unless output == nil or output == "" do
      IO.puts "#{String.trim_trailing(output)}"
    end
    unless attachment == nil do
      if output != nil and output != "" do
        IO.puts "----------"
      end
      IO.puts Poison.encode!(attachment, pretty: true)
    end
  end

  defp read_file(path) do
    case File.read(path) do
      {:ok, contents} ->
        {:ok, contents}
      {:error, reason} ->
        String.Chars.to_string(:file.format_error(reason))
    end
  end

  defp read_data(nil), do: {:ok, "{}"}
  defp read_data(path), do: read_file(path)

  defp render_template(template, data) do
    case Poison.decode(data) do
      {:error, _} ->
        "invalid JSON"
      {:ok, data} ->
        {:ok, engine} = Engine.new()
        engine = Engine.compile!(engine, @script_name, template)
        directives = Engine.eval!(engine, @script_name, data)
        Poison.decode(Poison.encode!(directives))
    end
  end



  defp version() do
    {:ok, vsn} = :application.get_key(:greenbar_exec, :vsn)
    String.Chars.to_string(vsn)
  end

  defp display_help() do
    IO.puts "#{@script_name} #{version()}\n"
    IO.puts "#{@script_name} (-s,--slack|-h,--hipchat) <template file> <data file>"
    IO.puts ""
    IO.puts "-s, --slack\tUse Slack template renderer"
    IO.puts "-h, --hipchat\tUse HipChat renderer"
    IO.puts "--help\t\tDisplay this help message"
    IO.puts ""
    IO.puts "<template file>\tPath to a Greenbar template"
    IO.puts "<data file>\tPath to a file containing valid JSON"
  end

end
