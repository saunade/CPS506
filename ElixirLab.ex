defmodule Lab4 do

  @moduledoc """
    Add your functions for lab 4 below. Fuction skeletons with dummy return values are provided.
    Your task is to fill in these functions to accomplish what is described in the lab description.
    You may also add additional helper functions if you desire.
    Hint: You'll need to add tail recursive signatures. See the MyEnum examples from class
    for examples of this.
    Test your code by running 'mix test' from the lab4 directory.
  """

  def catNestedStrings(items) do
    catNestedStrings(items, "")
  end
  defp catNestedStrings([], word), do: word
  defp catNestedStrings([head | rest], word) do
    result = case head do
      string when is_binary(string) -> word <> string
      nested when is_list(nested) -> catNestedStrings(nested, word)
      _ -> word
    end
    catNestedStrings(rest, result)
  end

  def filterNestedStrings(items) do
    filterNestedStrings(items, [])
  end
  defp filterNestedStrings([], result), do: Enum.reverse(result)
  defp filterNestedStrings([head | rest], result) when is_binary(head), do: filterNestedStrings(rest, result)
  defp filterNestedStrings([head | rest], result) when is_list(head), do: filterNestedStrings(rest, [filterNestedStrings(head,[]) | result])
  defp filterNestedStrings([head | rest], result), do: filterNestedStrings(rest, [head | result])

  def tailFib(n) do
    if (n == 0), do: 0
    tailFib(n, 1, 0)
  end
  defp tailFib(0, _, b), do: b
  defp tailFib(n, a, b), do: tailFib(n-1, a+b, a)

  def giveChange(n, coins), do: giveChange(n, coins, [])
  defp giveChange(n, _, list) when n == 0, do: Enum.reverse(list)
  defp giveChange(n, [], _) when n > 0, do: :error
  defp giveChange(n, [head | tail], list) do
    if ((n-head) >= 0), do: giveChange(n-head, [head | tail], [head | list]), else: giveChange(n, tail, list)
  end

  def reduce(list, fun), do: reduce((tl list), fun, (hd list), true)
  def reduce(list, acc, fun), do: reduce((tl list), fun, fun.((hd list), acc), true)
  defp reduce([], _, res, _), do: res
  defp reduce([h|t], f, res, hi), do: reduce(t, f, f.(h, res), hi)

  
end
