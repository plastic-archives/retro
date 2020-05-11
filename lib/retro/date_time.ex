defmodule Retro.DateTime do
  @moduledoc """
  DateTime Toolkit.
  """
  @moduledoc since: "0.1.0"

  alias Tzdata.TimeZoneDatabase

  defp get_default_time_zone() do
    Application.get_env(:retro, :time_zone_local_time)
  end

  @doc """
  Convert `%DateTime{}` to local time string.

  ## Examples

      iex> Retro.DateTime.to_local_time_string(~U[2020-05-11 07:39:41.509913Z], time_zone: "Asia/Shanghai")
      '2020-05-11 15:39:41'

  """
  @doc since: "0.1.0"
  def to_local_time_string!(%DateTime{} = date_time, opts \\ []) do
    time_zone = opts[:time_zone] || get_default_time_zone()

    %DateTime{
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second
    } = DateTime.shift_zone!(date_time, time_zone, TimeZoneDatabase)

    :io_lib.format("~4..0B-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B", [
      year,
      month,
      day,
      hour,
      minute,
      second
    ])
  end
end
