defmodule ExNotation.ParserTest do
  use ExUnit.Case

  alias ExNotation.Parser

  describe "infix_to_postfix/1" do
    test "converts an infix expression to postfix" do
      assert Parser.infix_to_postfix(["1", "+", "2"]) == [
               "1",
               "2",
               "+"
             ]

      assert Parser.infix_to_postfix(["1", "+", "2", "*", "3"]) == [
               "1",
               "2",
               "3",
               "*",
               "+"
             ]

      assert Parser.infix_to_postfix(["(", "1", "+", "2", ")", "*", "3"]) == [
               "1",
               "2",
               "+",
               "3",
               "*"
             ]
    end
  end
end
