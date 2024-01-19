defmodule ExNotation.NotationTest do
  use ExUnit.Case

  alias ExNotation.Notation

  describe "detect/1" do
    test "detects infix notation" do
      assert Notation.detect("1 + 2") == :infix
      assert Notation.detect("1 + (2 * 3)") == :infix

      assert Notation.detect(["1", "+", "2"]) == :infix
      assert Notation.detect(["1", "+", "2", "*", "3"]) == :infix
    end

    test "detects prefix notation" do
      assert Notation.detect("+ 1 2") == :prefix
      assert Notation.detect("+ 1 * 2 3") == :prefix

      assert Notation.detect(["+", "1", "2"]) == :prefix
      assert Notation.detect(["+", "1", "*", "2", "3"]) == :prefix
    end

    test "detects postfix notation" do
      assert Notation.detect("1 2 +") == :postfix
      assert Notation.detect("1 2 3 * +") == :postfix

      assert Notation.detect(["1", "2", "+"]) == :postfix
      assert Notation.detect(["1", "2", "3", "*", "+"]) == :postfix
    end

    test "a single value returns infix" do
      assert Notation.detect("1") == :infix
      assert Notation.detect(["1"]) == :infix
    end
  end
end
