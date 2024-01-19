defmodule ExNotation.Notation do
  @moduledoc """
  A module for handling the different notation types.
  """
  alias ExNotation.Tokeniser

  @doc """
  Detects the notation of an expression. The expression can
  be either a string or a list of tokens.

  ## Examples

      iex> ExNotation.Notation.detect("1 + 2")
      :infix
      iex> ExNotation.Notation.detect(["+", "1", "2"])
      :prefix
      iex> ExNotation.Notation.detect("1 2 +")
      :postfix
  """
  @spec detect(String.t() | list(String.t())) :: atom()
  def detect(expression) do
    case last_two_tokens(expression) do
      [second_last, last] -> determine_notation(second_last, last)
      [_value] -> :infix
    end
  end

  defp last_two_tokens(expression) when is_binary(expression) do
    expression
    |> tokenise()
    |> Enum.take(-2)
  end

  defp last_two_tokens(expression) when is_list(expression) do
    Enum.take(expression, -2)
  end

  defp tokenise(expression) do
    Tokeniser.tokenise(expression)
  end

  defp determine_notation(second_last, last) do
    cond do
      bracket?(last) -> :infix
      operator?(second_last) && value?(last) -> :infix
      operator?(last) -> :postfix
      value?(last) && value?(second_last) -> :prefix
      true -> raise "Unknown notation"
    end
  end

  defp operator?(token) do
    token in ["+", "-", "*", "/"]
  end

  defp bracket?(token) do
    token in ["(", ")"]
  end

  defp value?(token) do
    !operator?(token) && !bracket?(token)
  end
end
