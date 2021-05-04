defmodule Retro.Phoenix.HTML.SVGTest do
  use ExUnit.Case, async: true
  use Retro.Phoenix.HTML.SVG

  describe "svg(name, collection, opts)" do
    test "works with an HTML id" do
      actual = svg("test_icon", "generic", id: "the-logo")
      assert actual == {:safe, ~s|<svg id="the-logo"></svg>|}
    end

    test "works with an HTML class" do
      actual = svg("test_icon", "generic", class: "fill-current")
      assert actual == {:safe, ~s|<svg class="fill-current"></svg>|}
    end

    test "works with snake case HTMl class" do
      actual = svg("test_icon", "generic", aria_labelledby: "me")
      assert actual == {:safe, ~s|<svg aria-labelledby="me"></svg>|}
    end

    test "works with existing class" do
      actual = svg("test_icon_with_class", "generic", class: "fill-current")
      assert actual == {:safe, ~s|<svg class="existing-class fill-current"></svg>|}
    end

    test "works with an arbitrary attribute" do
      attr = Enum.random(["alice", "bob", "carol"])
      opts = [{attr, "value"}]
      actual = svg("test_icon", "generic", opts)
      assert actual == {:safe, ~s|<svg #{attr}="value"></svg>|}
    end
  end

  test "svg(name)" do
    actual = svg("test_icon")
    assert actual == {:safe, "<svg></svg>"}
  end

  test "svg(name, opts)" do
    actual = svg("test_icon", id: "the-logo")
    assert actual == {:safe, ~s|<svg id="the-logo"></svg>|}
  end

  test "svg(name, collection)" do
    actual = svg("test_icon", "generic")
    assert actual == {:safe, "<svg></svg>"}
  end
end
