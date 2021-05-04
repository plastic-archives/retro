defmodule Retro.Phoenix.HTML.SVG do
  @moduledoc """
  View helpers for rendering inline SVG.

  > The core code is borrowed from [nikkomiu/phoenix_inline_svg](https://github.com/nikkomiu/phoenix_inline_svg)
  > whose author has been gone for a long time.

  ## Import Helpers

  Add the following to the quoted `view` in your `my_app_web.ex` file.

      def view do
        quote do
          use Retro.Phoenix.HTML.SVG
        end
      end

  This will generate functions for each SVG file, effectively caching them at compile time.

  ## Usage

  ### render SVG from default collection

  ```eex
  <%= svg("home") %>
  ```

  It will load the SVG file from `assets/static/svg/generic/home.svg`, and inject
  the content of SVG file to HTML:

  ```html
  <svg>...</svg>
  ```

  ### render SVG from other collections

  You can break up SVG files into collections, and use the second argument of
  `svg/2` to specify the name of collection:

  ```eex
  <%= svg_image("user", "fontawesome") %>
  ```

  It will load the SVG file from `assets/static/svg/fontawesome/user.svg`, and
  inject the content of SVG file to HTML:

  ```html
  <svg>...</svg>
  ```

  ### render SVG with custom HTML attributes

  You can also pass optional HTML attributes into the function to set those
  attributes on the SVG:

  ```eex
  <%= svg("home", class: "logo", id: "bounce-animation") %>
  <%= svg("home", "fontawesome", class: "logo", id: "bounce-animation") %>
  ```

  It will output:

  ```html
  <svg class="logo" id="bounce-animation">...</svg>
  <svg class="logo" id="bounce-animation">...</svg>
  ```

  ## Configuration Options

  There are several configuration options for meeting your needs.

  ### `:dir`

  Specify the directory from which to load SVG files.

  The default value for standard way is `assets/static/svg/`.

  ```elixir
  config :retro, Retro.Phoenix.HTML.SVG,
    dir: "relative/path/to/the/root/of/project"
  ```

  ### `:default_collection`

  Specify the default collection to use.

  The deafult value is `generic`.

  ```elixir
  config :retro, Retro.Phoenix.HTML.SVG,
    default_collection: "fontawesome"
  ```

  ### `:not_found`

  Specify content to displayed in the `<i>` element when there is no SVG file found.

  The default value is:

  ```
  <svg viewbox='0 0 60 60'>
    <text x='0' y='40' font-size='30' font-weight='bold'
      font-family='monospace'>Error</text>
  </svg>
  ```

  ```elixir
  config :retro, Retro.Phoenix.HTML.SVG,
    not_found: "<p>Oh No!</p>"
  ```
  """

  alias Retro.Phoenix.HTML.SVG.Util

  @doc """
  The macro precompiles the SVG images into functions.
  """
  defmacro __using__(_) do
    get_config(:dir, "assets/static/svg/")
    |> find_collection_sets
    |> Enum.uniq()
    |> Enum.map(&create_cached_svg(&1))
  end

  defp find_collection_sets(svgs_path) do
    if File.dir?(svgs_path) do
      case File.ls(svgs_path) do
        {:ok, listed_files} ->
          listed_files
          |> Stream.filter(fn e -> File.dir?(Path.join(svgs_path, e)) end)
          |> Enum.flat_map(&map_collection(&1, svgs_path))

        _ ->
          []
      end
    else
      []
    end
  end

  defp map_collection(collection, svgs_path) do
    collection_path = Path.join(svgs_path, collection)

    collection_path
    |> File.ls!()
    |> Stream.map(&Path.join(collection_path, &1))
    |> Stream.flat_map(&to_file_path/1)
    |> Enum.map(&{collection, &1})
  end

  defp to_file_path(path) do
    if File.dir?(path) do
      path
      |> File.ls!()
      |> Stream.map(&Path.join(path, &1))
      |> Enum.flat_map(&to_file_path/1)
    else
      [path]
    end
  end

  defp create_cached_svg({collection, name}) do
    try do
      filename = hd(Regex.run(~r|.*/#{collection}/(.*)\.svg$|, name, capture: :all_but_first))

      content = read_svg_from_path(name)

      generic_functions =
        if get_config(:default_collection, "generic") == collection do
          quote do
            def svg(unquote(filename)) do
              svg(unquote(filename), unquote(collection), [])
            end

            def svg(unquote(filename), opts) when is_list(opts) do
              svg(unquote(filename), unquote(collection), opts)
            end
          end
        end

      explicit_functions =
        quote do
          def svg(unquote(filename), unquote(collection)) do
            svg(unquote(filename), unquote(collection), [])
          end

          def svg(unquote(filename), unquote(collection), opts) do
            unquote(content)
            |> Util.insert_attrs(opts)
            |> Util.safety_string()
          end
        end

      [generic_functions, explicit_functions]
    rescue
      ArgumentError -> nil
    end
  end

  defp read_svg_from_path(path) do
    case File.read(path) do
      {:ok, result} ->
        String.trim(result)

      {:error, _} ->
        get_config(
          :not_found,
          "<svg viewbox='0 0 60 60'>" <>
            "<text x='0' y='40' font-size='30' font-weight='bold'" <>
            "font-family='monospace'>Error</text></svg>"
        )
    end
  end

  defp get_config(key, default) do
    config = Application.get_env(:retro, __MODULE__, [])
    Keyword.get(config, key, default)
  end
end
