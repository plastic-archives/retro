defmodule Retro.Phoenix.Plug.ProxySensation do
  @moduledoc """
  Set endpoint base URL according to the proxy related headers.

  Derive scheme from following headers:
  * `x-forwarded-proto`

  Derive host from following headers:
  * `x-forwarded-host`
  * `x-forwarded-server`

  Devrive port from following headers:
  * `x-forwarded-port`

  ## Examples

      iex> base_url(%Plug.Conn{req_headers: [ {"x-forwarded-host", "example.com"}, {"x-forwarded-proto", "https"} ]})
      "https://example.com"

      iex> base_url(%Plug.Conn{})
      nil
  """
  @moduledoc since: "1.0.0"

  import Phoenix.Controller, only: [put_router_url: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    req_headers =
      conn
      |> Map.get(:req_headers)
      |> Enum.into(%{})

    scheme = Map.get(req_headers, "x-forwarded-proto")

    host =
      Map.get(req_headers, "x-forwarded-host") ||
        Map.get(req_headers, "x-forwarded-server")

    port = Map.get(req_headers, "x-forwarded-port")
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
end
