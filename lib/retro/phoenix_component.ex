defmodule Retro.Phoenix.Component do
  @moduledoc """
  Toolkit for creating components for Phoenix.

  Inspired by [Reusable Templates in Phoenix](https://blog.danielberkompas.com
  /2017/01/17/reusable-templates-in-phoenix/).

  ## Usage
  ### Import `Retro.Phoenix.Component`

      defmodule SampleWeb do
        def view do
          quote do
            # ...

            use Retro.Phoenix.Component,
              view: SampleWeb.ComponentView,
              type: :html

            # ...
          end
        end
      end


  ### Create a `SampleWeb.ComponentView`:

      defmodule SampleWeb.ComponentView do
        use SampleWeb, :view
      end


  ### Create `templates/component` directory

  It's used for storing templates for above view.


  ### Create a template

  Edit `templates/component/example.html`:

      <div class="<%= @class %>">
        <%= @inner %>
      </div>


  ### Use the template

      <%= c :example, class: "modal" do %>
         <p>Hello World</p>
         <button>OK</button>
      <% end %>
  """

  @moduledoc since: "0.3.0"

  import Phoenix.View, only: [render: 3]

  # TODO: Find a good method to move functions out of __using__/1
  defmacro __using__(view: view, type: type) do
    quote do
      defp do_component(template, assigns, block) do
        render(
          unquote(view),
          "#{template}.#{unquote(type)}",
          Keyword.merge(assigns, inner: block)
        )
      end

      @doc """
      Render a component by template name.

      ## Example

          <%= component "text_input.html" %>

      """
      def component(template) do
        do_component(template, [], "")
      end

      @doc """
      Render a component by template name and inner block.

      ## Example

          <%= component "form.html" do %>
            <%= component "text_input.html" %>
          <% end %>

      """
      def component(template, do: block) do
        do_component(template, [], block)
      end

      @doc """
      Render a component by template name and assigns.

      ## Example

          <%= component "text_input.html", class: "form-control" %>

      """
      def component(template, assigns) when is_list(assigns) do
        do_component(template, assigns, "")
      end

      @doc """
      Render a component by template name, assigns and inner block.

      ## Example

          <%= component "form.html", class: "form-control" do %>
            <%= component "text_input.html" %>
          <% end %>

      """
      def component(template, assigns, do: block) when is_list(assigns) do
        do_component(template, assigns, block)
      end

      @doc """
      Define aliases for components.

      ## Example

          <%= c "form.html", class: "form-control" do %>
            <%= c "text_input.html" %>
          <% end %>
      """
      defdelegate c(template),
        to: __MODULE__,
        as: :component

      defdelegate c(template, assigns_or_block),
        to: __MODULE__,
        as: :component

      defdelegate c(template, assigns, optional_block),
        to: __MODULE__,
        as: :component
    end
  end
end
