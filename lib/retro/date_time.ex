defmodule Retro.DateTime do
  alias Tzdata.TimeZoneDatabase

  def get_default_time_zone() do
    Application.get_env(:retro, :time_zone_local_time)
  end

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
