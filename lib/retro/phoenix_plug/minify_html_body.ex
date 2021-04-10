defmodule Retro.Phoenix.Plug.MinifyHtmlBody do
  @moduledoc """
  A plug that minifies the response body when the content type of response is
  `text/html`.

  # Usage

  ```elixir
  pipeline :browser do
    plug :accepts, ["html"]
    # ...
    plug Retro.Phoenix.Plug.MinifyHtmlBody
  end
  ```

  # Reference

  + https://github.com/gravityblast/minify_response
  """

  @doc false
  def init(opts \\ []), do: opts

  @doc false
  def call(%Plug.Conn{} = conn, _opts) do
    Plug.Conn.register_before_send(conn, &minify_html/1)
  end

  @doc false
  def minify_html(%Plug.Conn{} = conn) do
    case List.keyfind(conn.resp_headers, "content-type", 0) do
      {_, "text/html" <> _} ->
        body =
          conn.resp_body
          |> Floki.parse_document!()
          |> Floki.raw_html()

        %Plug.Conn{conn | resp_body: body}

      _ ->
        conn
    end
  end
end
