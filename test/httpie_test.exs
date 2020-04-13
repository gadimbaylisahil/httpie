defmodule HttpieTest do
  use ExUnit.Case
  doctest Httpie

  test "greets the world" do
    assert Httpie.hello() == :world
  end
end
