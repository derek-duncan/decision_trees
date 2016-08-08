defmodule DecisionTrees do

  def seed do
    items = [
      [body: "aluminum", weight: 2, color: "gray"],
      [body: "plastic", weight: 4, color: "black"],
      [body: "plastic", weight: 2, color: "gray"],
      [body: "aluminum", weight: 5, color: "red"],
      [body: "plastic", weight: 1, color: "white"],
    ]
  end

  @doc ~S"""
  Divide items into two children lists

  ## Examples

    iex> items = [
    ...> [body: "aluminum", weight: 2, color: "gray"],
    ...> [body: "plastic", weight: 4, color: "black"],
    ...> [body: "plastic", weight: 2, color: "gray"],
    ...> [body: "aluminum", weight: 5, color: "red"]
    ...> ]
    iex> DecisionTrees.divide_items(items, :body, "aluminum")
    {
      [
        [body: "aluminum", weight: 2, color: "gray"],
        [body: "aluminum", weight: 5, color: "red"]
      ],
      [
        [body: "plastic", weight: 4, color: "black"],
        [body: "plastic", weight: 2, color: "gray"]
      ]
    }
  """
  def divide_items(items, split_key, split_value) do
    Enum.partition(items, &(decide_split(&1[split_key], split_value)))
  end

  defp decide_split(value, split_value) when is_number(value) and is_number(split_value), do: value >= split_value
  defp decide_split(value, split_value), do: value == split_value

  @doc """
  Count the values of a specific key in a list of items
  """
  def unique_counts(items, unique_key),
    do: do_unique_counts(items, %{}, unique_key)

  defp do_unique_counts([ head | tail], counts, unique_key) do
    unique_value_key = head[unique_key]
    old_value = Map.get(counts, unique_value_key, 0)
    new_counts = Map.put(counts, unique_value_key, old_value + 1)
    do_unique_counts(tail, new_counts, unique_key)
  end

  defp do_unique_counts([], counts, _), do: counts

  @doc """
  Calculates the entropy of a list's values
  """
  def entropy(items, unique_key) do
    unique_counts(items, unique_key) |> do_entropy(length(items))
  end

  # Calculate entropy
  @spec do_entropy(number, number) :: number
  defp do_entropy(counts, len) do
    log2 = &(:math.log(&1) / :math.log(2))
    Enum.reduce(Map.keys(counts), 0, fn key, acc ->
      p = counts[key] / len
      acc - p * log2.(p)
    end)
  end
end
