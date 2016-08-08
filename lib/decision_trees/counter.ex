defmodule DecisionTrees.Counter do
  @doc """
  Count the values of a specific key in a list of dataset
  """
  def unique_values(dataset, target_key) do
    do_unique_values(dataset, %{}, target_key)
  end

  defp do_unique_values([ set | sets], counts, target_key) do
    unique_value_key = set[target_key]
    old_value = Map.get(counts, unique_value_key, 0)
    new_counts = Map.put(counts, unique_value_key, old_value + 1)
    do_unique_values(sets, new_counts, target_key)
  end

  defp do_unique_values([], counts, _), do: counts
end
