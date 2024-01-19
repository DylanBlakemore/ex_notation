defmodule ExNotation.Tokeniser do
  @moduledoc """
  Tokenises a string.
  """

  @doc """
  Tokenizes a string.
  """
  @spec tokenise(String.t()) :: list(String.t())
  def tokenise(expression) do
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
end
