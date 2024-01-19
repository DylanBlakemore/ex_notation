defmodule ExNotation.Expression do
  @moduledoc """
  An Expression represents a mathematical expression
  in some notation. The notation can be one of:
  - infix
  - prefix
  - postfix
  """
  alias ExNotation.{Notation, Parser, Tokeniser}
  defstruct [:notation, :expression, tokens: []]

  @type t :: %__MODULE__{
          notation: :infix | :prefix | :postfix,
          expression: String.t(),
          tokens: list(String.t())
        }

  @doc """
  Creates a new expression by automatically detecting the notation
  and tokenising the expression.
  """
  @spec new(String.t()) :: t()
  def new(expression) do
    notation = Notation.detect(expression)

    %__MODULE__{notation: notation, expression: expression}
    |> tokenize()
  end

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
    Tokeniser.tokenise(expression)
  end

  def tokenize(%__MODULE__{expression: expression, tokens: []} = exp) do
    %{exp | tokens: tokenize(expression)}
  end

  def tokenize(%__MODULE__{} = exp) do
    exp
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
    Notation.detect(expression)
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

  @doc """
  Converts to postifx notation.
  """
  @spec to_postfix(t()) :: t()
  def to_postfix(%__MODULE__{notation: :postfix} = exp) do
    exp
  end

  def to_postfix(%__MODULE__{notation: :infix, expression: expression}) do
    expression
    |> Parser.infix_to_postfix()
    |> postfix()
  end
end
