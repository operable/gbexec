defmodule GreenbarExec.Options do

  def which_renderer?(options) do
    if use_slack?(options) do
      :slack
    else
      if use_hipchat?(options) do
        :hipchat
      else
        :none
      end
    end
  end

  def use_slack?(options) do
    processor_enabled?(options, :slack, :s)
  end

  def use_hipchat?(options) do
    processor_enabled?(options, :hipchat, :h)
  end

  defp processor_enabled?(options, long_name, short_name) do
    cond do
      Keyword.get(options, long_name, false) ->
        true
      Keyword.get(options, short_name, false) ->
        true
      true ->
        false
    end
  end

end
