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

  describe "postfix_to_s_expression/1" do
    test "converts a postfix expression to an s-expression" do
      assert Parser.postfix_to_s_expression(["1", "2", "+"]) == {"+", ["1", "2"]}

      assert Parser.postfix_to_s_expression(["1", "2", "+", "3", "*"]) == {
               "*",
               [{"+", ["1", "2"]}, "3"]
             }

      assert Parser.postfix_to_s_expression(["1", "2", "+", "3", "*", "4", "+"]) == {
               "+",
               [{"*", [{"+", ["1", "2"]}, "3"]}, "4"]
             }
    end
  end
end
