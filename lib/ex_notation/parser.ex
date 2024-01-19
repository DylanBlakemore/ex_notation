defmodule ExNotation.Parser do
  alias ExNotation.{Tokeniser, ShuntingYard}

  @doc """
  Converts an infix expression to postfix notation.
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
end
