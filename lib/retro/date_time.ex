defmodule Retro.DateTime do
  alias Tzdata.TimeZoneDatabase

  def to_local_time_string!(%DateTime{} = datetime, timezone \\ "Asia/Shanghai") do
    %DateTime{
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second
    } = DateTime.shift_zone!(datetime, timezone, TimeZoneDatabase)

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
