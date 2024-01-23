defmodule ExNotation.Parser do
  alias ExNotation.{Tokeniser, ShuntingYard}

  @operators ["+", "-", "*", "/"]

  @doc """
  Converts an infix expression to postfix notation.

  ## Examples

      iex> ExNotation.Parser.infix_to_postfix(["1", "+", "2"])
      ["1", "2", "+"]
      iex> ExNotation.Parser.infix_to_postfix(["1", "+", "2", "*", "3"])
      ["1", "2", "3", "*", "+"]
  """
  @spec infix_to_postfix(String.t() | list(String.t())) :: String.t() | list(String.t())
  def infix_to_postfix(tokens) when is_list(tokens) do
    tokens
    |> ShuntingYard.run()
  end

  def infix_to_postfix(expression) when is_binary(expression) do
    expression
    |> Tokeniser.tokenise()
    |> infix_to_postfix()
    |> Enum.join(" ")
  end

  @doc """
  Converts a postfix expression to an s-expression.

  ## Examples

      iex> ExNotation.Parser.postfix_to_s_expression(["1", "2", "+"])
      {"+", {"1", "2"}}
      iex> ExNotation.Parser.postfix_to_s_expression(["1", "2", "+", "3", "*"])
      {"*", {{"+", {"1", "2"}}, "3"}}
      iex> ExNotation.Parser.postfix_to_s_expression(["1", "2", "+", "3", "*", "4", "+"])
      {"+", {{"*", {{"+", {"1", "2"}}, "3"}}, "4"}}
  """
  @spec postfix_to_s_expression(String.t() | list(String.t())) :: tuple()
  def postfix_to_s_expression(tokens) do
    tokens
    |> Enum.reduce([], &handle_token/2)
    |> List.first()
  end

  defp handle_token(token, stack) when token in @operators do
    [right_op, left_op | rest] = stack
    [{token, [left_op, right_op]} | rest]
  end

  defp handle_token(token, stack),
    do: [token | stack]
end
