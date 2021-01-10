defmodule Retro.Plug.HealthCheck do
  @moduledoc """
  Health checks can be used for liveness or readiness probes.

  Health checks are separated from the functionality of the application, because
  of that, it's better to minimize the impact on application.

  They should meet the following requirements:
  1. run as light as possible.
  2. not generate logs.

  ## Usage

  The basic idea is adding it to the top of plugs.

  Add it to the top of `endpoint.ex` in Phoenix:

  ```elixir
  defmodule HelloWeb.Endpoint do
    use Phoenix.Endpoint, otp_app: :hello

    # Put the health check here, before anything else
    plug Retro.Plug.HealthCheck
  end
  ```

  ## References

  + [Health checks for Plug and Phoenix](https://blog.jola.dev/health-checks-for-plug-and-phoenix)

  """

  import Plug.Conn

  def init(opts) do
    path = Keyword.get(opts, :path, "/health-check")
    status = Keyword.get(opts, :status, 200)
    body = Keyword.get(opts, :body, "")

    [
      path: path,
      status: status,
      body: body
    ]
  end

  def call(%Plug.Conn{request_path: request_path} = conn, opts)
      when request_path === opts[:path] do
    conn
    |> send_resp(opts[:status], opts[:body])
    |> halt()
  end

  def call(conn, _opts), do: conn
end
