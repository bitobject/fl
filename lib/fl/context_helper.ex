defmodule Fl.ContextHelper do
  @moduledoc false

  def get_timestamps_by_period(period, timezone, opts \\ [])

  def get_timestamps_by_period(:year, timezone, opts) do
    time = Timex.now(timezone)

    start_ts =
      time
      |> Timex.beginning_of_year()
      |> to_type(opts)

    end_ts =
      time
      |> Timex.end_of_year()
      |> to_type(opts)

    {start_ts, end_ts}
  end

  def get_timestamps_by_period(:month, timezone, opts) do
    time = Timex.now(timezone)

    start_ts =
      time
      |> Timex.beginning_of_month()
      |> to_type(opts)

    end_ts =
      time
      |> Timex.end_of_month()
      |> to_type(opts)

    {start_ts, end_ts}
  end

  def get_timestamps_by_period(:week, timezone, opts) do
    time = Timex.now(timezone)

    start_ts =
      time
      |> Timex.beginning_of_week()
      |> to_type(opts)

    end_ts =
      time
      |> Timex.end_of_week()
      |> to_type(opts)

    {start_ts, end_ts}
  end

  def get_timestamps_by_period(:day, timezone, opts) do
    time = Timex.now(timezone)

    start_ts =
      time
      |> Timex.beginning_of_day()
      |> to_type(opts)

    end_ts =
      time
      |> Timex.end_of_day()
      |> to_type(opts)

    {start_ts, end_ts}
  end

  defp to_type(time, type: :unix), do: Timex.to_unix(time)
  defp to_type(time, type: :string), do: to_string(time)
  defp to_type(time, _list), do: time
end
