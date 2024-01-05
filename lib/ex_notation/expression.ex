defmodule ExNotation.Expression do
  @moduledoc """
  An Expression represents a mathematical expression
  in some notation. The notation can be one of:
  - infix
  - prefix
  - postfix
  """
  defstruct [:notation, :expression, tokens: []]

  @type t :: %__MODULE__{
          notation: :infix | :prefix | :postfix,
          expression: String.t(),
          tokens: list(String.t())
        }

  @doc """
  Tokenizes a string.

  ## Examples

      iex> ExNotation.Expression.tokenize("(5 + x1) * y_2 - z")
      ["(", "5", "+", "x1", ")", "*", "y_2", "-", "z"]
      iex> ExNotation.Expression.tokenize("+ 1 2")
      ["+", "1", "2"]
      iex> ExNotation.Expression.tokenize("1 2 +")
      ["1", "2", "+"]
  """
  @spec tokenize(String.t() | t()) :: list(String.t()) | t()
  def tokenize(expression) when is_binary(expression) do
    expression
    |> String.trim()
    |> String.split(~r/\s+/)
    |> Enum.flat_map(
      &String.split(
        &1,
        ~r/(\+|-|\*|\/|\(|\))/,
        include_captures: true,
        trim: true
      )
    )
  end

  def tokenize(%__MODULE__{expression: expression} = exp) do
    %{exp | tokens: tokenize(expression)}
  end

  @doc """
  Detects the notation of an expression.

  ## Examples

      iex> ExNotation.Expression.detect_notation("1 + 2")
      :infix
      iex> ExNotation.Expression.detect_notation("+ 1 2")
      :prefix
      iex> ExNotation.Expression.detect_notation("1 2 +")
      :postfix
  """
  @spec detect_notation(String.t()) :: atom()
  def detect_notation(expression) do
    case last_two_tokens(expression) do
      [second_last, last] -> determine_notation(second_last, last)
      [_value] -> :infix
    end
  end

  defp last_two_tokens(expression) do
    expression
    |> tokenize()
    |> Enum.take(-2)
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

  @doc """
  Create an infix expression from a string.

  ## Examples

      iex> ExNotation.Expression.infix("1 + 2")
      %ExNotation.Expression{expression: "1 + 2", tokens: [], type: :infix}
  """
  @spec infix(String.t()) :: t()
  def infix(expression) do
    %__MODULE__{notation: :infix, expression: expression}
    |> tokenize()
  end

  @doc """
  Create a prefix expression from a string.

  ## Examples

      iex> ExNotation.Expression.prefix("+ 1 2")
      %ExNotation.Expression{expression: "+ 1 2", tokens: [], notation: :prefix}
  """
  @spec prefix(String.t()) :: t()
  def prefix(expression) do
    %__MODULE__{notation: :prefix, expression: expression}
    |> tokenize()
  end

  @doc """
  Create a postfix expression from a string.

  ## Examples

      iex> ExNotation.Expression.postfix("1 2 +")
      %ExNotation.Expression{expression: "1 2 +", tokens: [], notation: :postfix}
  """
  @spec postfix(String.t()) :: t()
  def postfix(expression) do
    %__MODULE__{notation: :postfix, expression: expression}
    |> tokenize()
  end
end
