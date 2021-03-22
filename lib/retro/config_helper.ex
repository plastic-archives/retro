defmodule Retro.ConfigHelper do
  @moduledoc """
  Helpers for `config/*.exs`.
  """

  @doc """
  Parse the url of Phoenix endpoint.

  When deploying Phoenix application behind a proxy, it is common to specify the
  `:url` option of Phoenix endpoint like this:

      config :demo_web, DemoWeb.Endpoint,
        url: [scheme: "https", host: "example.com", port: 443, path: "/"],
        check_origin: ["https://example.com/"],
        # ...

  As you can see, the config is verbose because `:url` and `:check_origin` are sharing
  the same pieces of data.

  In order to remove this kind of verbose, we can write something like:

      import Retro.ConfigHelper

      base_url = "https://example.com/"

      config :demo_web, DemoWeb.Endpoint,
        url: parse_phoenix_endpoint_url(base_url),
        check_origin: [base_url],
        # ...

  Much better.
  """
  def parse_phoenix_endpoint_url(url) do
    %URI{scheme: scheme, host: host, port: port, path: path} = URI.parse(url)
    [scheme: scheme, host: host, port: port, path: path]
  end

  @doc """
  Extract host from url.
  """
  def extract_host(url) do
    %URI{host: host} = URI.parse(url)
    host
  end
end
