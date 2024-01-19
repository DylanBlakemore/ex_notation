defmodule ExNotation.ShuntingUardTest do
  use ExUnit.Case

  alias ExNotation.ShuntingYard

  describe "run/1" do
    test "converts an infix expression to postfix" do
      assert ShuntingYard.run(["1", "+", "2"]) == ["1", "2", "+"]
      assert ShuntingYard.run(["1", "+", "2", "*", "3"]) == ["1", "2", "3", "*", "+"]
      assert ShuntingYard.run(["(", "1", "+", "2", ")", "*", "3"]) == ["1", "2", "+", "3", "*"]
    end
  end
end
