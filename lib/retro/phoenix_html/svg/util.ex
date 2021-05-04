defmodule Retro.Phoenix.HTML.SVG.Util do
  def insert_attrs(html, []), do: html

  def insert_attrs(html, attrs) do
    Enum.reduce(attrs, html, fn {attr, value}, acc ->
      attr =
        attr
        |> to_string
        |> String.replace("_", "-")

      acc
      |> Floki.parse_fragment()
      |> case do
        {:ok, html_tree} ->
          html_tree
          |> Floki.attr("svg", attr, &String.trim("#{&1} #{value}"))
          |> Floki.raw_html()

        {:error, html} ->
          raise("Unable to parse html\n#{html}")
      end
    end)
  end

  def safety_string(html) do
    {:safe, html}
  end
end
