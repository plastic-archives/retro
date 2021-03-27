defmodule Retro.Phoenix.HTML.Link do
  @moduledoc """
  Toolkit for extending `Phoenix.HTML.Link`.
  """
  @moduledoc since: "0.2.0"

  import Phoenix.HTML.Link

  @doc """
  Generates a external link to the given URL with vulnerability care. Get more
  details by reading:
  + [Open link in new tab or window](https://stackoverflow.com/a/15551842)
  + [Prevent Reverse Tabnabbing Attacks With Proper noopener, noreferrer, and nofollow Attribution](https://web.archive.org/web/20201225051333/https://blog.bhanuteja.dev/noopener-noreferrer-and-nofollow-when-to-use-them-how-can-these-prevent-phishing-attacks?guid=none&deviceId=4b2457f9-8062-46ca-a224-b24488072b1c)

  This function is same as `Phoenix.HTML.Link.link/2` except that it adds two
  additional options:

      [
        target: "_blank",
        rel: "noopener noreferrer"
      ]

  ## Examples

      iex> external_link("open page", to: "https://example.com") |> Phoenix.HTML.safe_to_string
      "<a href=\\"https://example.com\\" rel=\\"noopener noreferrer\\" target=\\"_blank\\">open page</a>"

      iex> external_link("open page", to: "https://example.com", rel: "nofollow") |> Phoenix.HTML.safe_to_string
      "<a href=\\"https://example.com\\" rel=\\"noopener noreferrer nofollow\\" target=\\"_blank\\">open page</a>"

  """
  @doc since: "0.2.0"
  def external_link(opts, do: contents) when is_list(opts) do
    external_link(contents, opts)
  end

  def external_link(contents, opts) do
    default_rel = "noopener noreferrer"

    rel =
      case Keyword.get(opts, :rel) do
        nil -> default_rel
        new_rel -> "#{default_rel} #{new_rel}"
      end

    opts = Keyword.delete(opts, :rel)

    link(
      contents,
      Keyword.merge(
        [
          target: "_blank",
          rel: rel
        ],
        opts
      )
    )
  end
end
