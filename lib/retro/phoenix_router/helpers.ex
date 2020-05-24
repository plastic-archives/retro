defmodule Retro.Phoenix.Router.Helpers do
  @moduledoc """
  Toolkit for extending `Phoenix.Router.Helpers`.
  """
  @moduledoc since: "0.3.0"

  @doc """
  Generates the connection/endpoint base URL according to reverse proxy related
  headers.

  Derive protocol from following headers:
  * `x-forwarded-proto`

  Derive host from following headers:
  * `x-forwarded-host`
  * `x-forwarded-server`

  ## Examples

      iex> base_url(%Plug.Conn{req_headers: [ {"x-forwarded-host", "example.com"}, {"x-forwarded-proto", "https"} ]})
      "https://example.com"

      iex> base_url(%Plug.Conn{})
      nil

  """
  @doc since: "0.3.0"
  def base_url(%Plug.Conn{} = conn) do
    req_headers =
      conn
      |> Map.get(:req_headers)
      |> Enum.into(%{})

    protocol = Map.get(req_headers, "x-forwarded-proto")

    host =
      Map.get(req_headers, "x-forwarded-host") ||
        Map.get(req_headers, "x-forwarded-server")

    if protocol && host do
      "#{protocol}://#{host}"
    else
      nil
    end
  end
end
