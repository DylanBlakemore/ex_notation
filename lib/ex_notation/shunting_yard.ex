defmodule ExNotation.ShuntingYard do
  @moduledoc """
  The Shunting Yard algorithm is used to convert an infix expression
  to postfix notation.
  """
  @operator_precedence %{
    "^" => 4,
    "*" => 3,
    "/" => 3,
    "+" => 2,
    "-" => 2,
    "(" => 1
  }

  @doc """
  Converts an infix expression to postfix notation.

  ## Examples

      iex> ExNotation.ShuntingYard.run(["1", "+", "2"])
      ["1", "2", "+"]
      iex> ExNotation.ShuntingYard.run(["1", "+", "2", "*", "3"])
      ["1", "2", "3", "*", "+"]
  """
  @spec run(list()) :: list()
  def run(infix_expr) do
    infix_expr
    |> Enum.reduce({[], []}, fn token, {output_queue, op_stack} ->
      handle_token(token, output_queue, op_stack)
    end)
    |> flush_operators()
    |> Enum.reverse()
  end

  defp handle_token("(", output_queue, op_stack), do: {output_queue, ["(" | op_stack]}

  defp handle_token(")", output_queue, op_stack) do
    {queue, stack} = pop_until_open_paren(output_queue, op_stack)
    {queue, stack}
  end

  defp handle_token(operator, output_queue, op_stack)
       when is_map_key(@operator_precedence, operator) do
    {queue, stack} = pop_higher_precedence_ops(output_queue, op_stack, operator)
    {queue, [operator | stack]}
  end

  defp handle_token(number_or_variable, output_queue, op_stack) do
    {[number_or_variable | output_queue], op_stack}
  end

  defp pop_until_open_paren(queue, stack) do
    {ops, rest} = stack |> Enum.split_while(&(&1 != "("))
    {Enum.reverse(ops) ++ queue, tl(rest)}
  end

  defp pop_higher_precedence_ops(queue, stack, operator) do
    {ops, rest} =
      stack
      |> Enum.split_while(fn op -> op_prec(op) >= op_prec(operator) end)

    {Enum.reverse(ops) ++ queue, rest}
  end

  defp op_prec(op) do
    @operator_precedence[op]
  end

  defp flush_operators({queue, stack}) do
    Enum.reverse(stack) ++ queue
  end
end
