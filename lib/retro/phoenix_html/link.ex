defmodule Retro.Phoenix.HTML.Link do
  @moduledoc """
  Toolkit for extending `Phoenix.HTML.Link`.
  """
  @moduledoc since: "0.2.0"

  import Phoenix.HTML.Link

  @doc """
  Generates a external link to the given URL with vulnerability care. Get more
  details at [here](https://stackoverflow.com/a/15551842).

  This function is same as `Phoenix.HTML.Link.link/2` except that it adds two
  additional options:

      [
        target: "_blank",
        rel: "noopener noreferrer"
      ]

  ## Examples

      iex> external_link("open page", to: "https://example.com") |> Phoenix.HTML.safe_to_string
      "<a href=\\"https://example.com\\" rel=\\"noopener noreferrer\\" target=\\"_blank\\">open page</a>"

  """
  @doc since: "0.2.0"
  def external_link(opts, do: contents) when is_list(opts) do
    external_link(contents, opts)
  end

  def external_link(contents, opts) do
    default_opts = [
      target: "_blank",
      rel: "noopener noreferrer"
    ]

    opts = Keyword.merge(default_opts, opts)

    link(contents, opts)
  end
end
