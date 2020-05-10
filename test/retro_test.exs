defmodule RetroTest do
  use ExUnit.Case
  doctest Retro

  test "greets the world" do
    assert Retro.hello() == :world
  end
end
