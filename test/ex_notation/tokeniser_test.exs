defmodule ExNotation.TokeniserTest do
  use ExUnit.Case

  alias ExNotation.Tokeniser

  describe "tokenise/1" do
    test "tokenises a simple addition" do
      assert Tokeniser.tokenise("1 + 2") == ["1", "+", "2"]
    end

    test "tokenises brackets" do
      assert Tokeniser.tokenise("(1 + 2)") == ["(", "1", "+", "2", ")"]
    end

    test "tokenises variables" do
      assert Tokeniser.tokenise("x + y") == ["x", "+", "y"]
    end

    test "tokenises complex expressions" do
      assert Tokeniser.tokenise("(5 + x1) * y_2 - z") == [
               "(",
               "5",
               "+",
               "x1",
               ")",
               "*",
               "y_2",
               "-",
               "z"
             ]
    end
  end
end
