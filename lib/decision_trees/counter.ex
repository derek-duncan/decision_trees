defmodule DecisionTrees.Counter do
  @doc """
  Count the values of a specific key in a list of dataset
  """
  def unique_values(dataset, target_key) do
    Enum.reduce(dataset, %{}, fn item, acc ->
      Map.update(acc, item[target_key], 0, &(&1 + 1))
    end)
  end
end
