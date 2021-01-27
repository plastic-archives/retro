defmodule Retro.Phoenix.Plug.ProxySensation do
  @moduledoc """
  Set endpoint base URL according to the proxy related headers.

  Derive scheme from following headers:
  * `x-forwarded-proto`

  Derive host from following headers:
  * `x-forwarded-host`
  * `x-forwarded-server`

  Derive port from following headers:
  * `x-forwarded-port`

  Derive remote_ip from following headers:
  * `x-forwarded-for`
  * `x-real-ip`


  # Configuration

  The :remote_ip is available as [logger metadata](https://hexdocs.pm/logger/master/Logger.html#module-metadata).
  To see the IP address in your log output, configure your logger backends to
  include the :remote_ip metadata:

  ```elixir
  config :logger, :console,
    format: "$time $metadata[$level] $message\n",
    metadata: [:request_id, :remote_ip]
  ```

  """
  @moduledoc since: "1.0.0"

  import Phoenix.Controller, only: [put_router_url: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    headers =
      conn
      |> Map.get(:req_headers)
      |> Enum.into(%{})

    conn
    |> resolve_router_url(headers)
    |> resolve_remote_ip(headers)
  end

  def resolve_router_url(conn, headers) do
    scheme = Map.get(headers, "x-forwarded-proto")

    host =
      Map.get(headers, "x-forwarded-host") ||
        Map.get(headers, "x-forwarded-server")

    port = Map.get(headers, "x-forwarded-port")
    port = port && String.to_integer(port)

    if scheme && host do
      put_router_url(conn, %URI{
        scheme: scheme,
        host: host,
        port: port
      })
    else
      conn
    end
  end

  def resolve_remote_ip(conn, headers) do
    ip = Map.get(headers, "x-forwarded-for") || Map.get(headers, "x-real-ip")

    Logger.metadata(remote_ip: ip)

    case parse_ip(ip) do
      {:error, _} ->
        conn

      {:ok, remote_ip} ->
        %{conn | remote_ip: remote_ip}
    end
  end

  defp parse_ip(nil) do
    {:error, :empty}
  end

  defp parse_ip(ip) do
    ip |> to_charlist |> :inet.parse_strict_address()
  end
end
