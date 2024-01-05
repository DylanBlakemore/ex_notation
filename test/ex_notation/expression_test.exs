defmodule ExNotation.ExpressionTest do
  use ExUnit.Case

  alias ExNotation.Expression

  describe "tokenize/1" do
    test "tokenizes a string" do
      assert Expression.tokenize("(5 + x1) * y_2 - z") == [
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

      assert Expression.tokenize("+ 1 2") == ["+", "1", "2"]

      assert Expression.tokenize("1 2 +") == ["1", "2", "+"]
    end

    test "tokenizes an expression" do
      assert %Expression{tokens: ["1", "+", "2"]} = Expression.tokenize(Expression.infix("1 + 2"))

      assert %Expression{tokens: ["+", "1", "2"]} =
               Expression.tokenize(Expression.prefix("+ 1 2"))

      assert %Expression{tokens: ["1", "2", "+"]} =
               Expression.tokenize(Expression.postfix("1 2 +"))
    end
  end

  describe "detect_notation" do
    test "detects infix notation" do
      assert Expression.detect_notation("1 + 2") == :infix
      assert Expression.detect_notation("1 + (2 * 3)") == :infix
    end

    test "detects prefix notation" do
      assert Expression.detect_notation("+ 1 2") == :prefix
      assert Expression.detect_notation("+ 1 * 2 3") == :prefix
    end

    test "detects postfix notation" do
      assert Expression.detect_notation("1 2 +") == :postfix
      assert Expression.detect_notation("1 2 3 * +") == :postfix
    end

    test "a single value returns infix" do
      assert Expression.detect_notation("1") == :infix
    end
  end

  describe "infix/1" do
    test "creates an infix expression" do
      assert Expression.infix("1 + 2") == %Expression{
               expression: "1 + 2",
               tokens: ["1", "+", "2"],
               notation: :infix
             }
    end
  end

  describe "prefix/1" do
    test "creates a prefix expression" do
      assert Expression.prefix("+ 1 2") == %Expression{
               expression: "+ 1 2",
               tokens: ["+", "1", "2"],
               notation: :prefix
             }
    end
  end

  describe "postfix/1" do
    test "creates a postfix expression" do
      assert Expression.postfix("1 2 +") == %Expression{
               expression: "1 2 +",
               tokens: ["1", "2", "+"],
               notation: :postfix
             }
    end
  end
end
