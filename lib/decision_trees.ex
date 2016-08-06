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

  @doc """
  Divide a items into two children lists
  """
  def divide_items(items, split_key, split_value) do
    # Divide the items into two segments
    divided_list = items
    |> Enum.partition(&(decide_split(&1[split_key], split_value)))
  end

  defp decide_split(value, split_value)
  when is_number(value) and is_number(split_value) do
    value >= split_value
  end

  defp decide_split(value, split_value), do: value == split_value

  @doc """
  Gets the count of values for a specific key
  """
  def unique_counts([ head | tail], counts, unique_key) do
    unique_value = head[unique_key]
    old_value = Map.get(counts, unique_value, 0)
    new_counts = Map.put(counts, unique_value, old_value + 1)

    unique_counts(tail, new_counts, unique_key)
  end
  def unique_counts([], counts, _), do: counts

  @doc """
  Calculates the entropy of a list's values
  """
  def entropy(items) do
    # Calculate entropy
    log2 = &(:math.log(&1) / :math.log(2))
    results = unique_counts(items, %{}, :weight)

    Enum.reduce(Map.keys(results), fn key, acc ->
      p = results[key] / length(items)
      acc - p * log2.(p)
    end)
  end
end
