defmodule RetroTest do
  use ExUnit.Case, async: true
  doctest Retro
end

defmodule Retro.Phoenix.HTML.LinkTest do
  use ExUnit.Case, async: true
  doctest Retro.Phoenix.HTML.Link, import: true
end

defmodule Retro.Phoenix.Router.HelpersTest do
  use ExUnit.Case, async: true
  doctest Retro.Phoenix.Router.Helpers, import: true
end
