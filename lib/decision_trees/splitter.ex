defmodule DecisionTrees.Splitter do
  @doc ~S"""
  Divide items into two children lists
  """
  def data(dataset_map, split_key, split_value) do
    dataset_map
    |> Enum.partition(fn data -> compare_for_split?(data[split_key], split_value) end)
  end

  # Number comparison
  defp compare_for_split?(value, split_value) when is_number(value) and is_number(split_value) do
    value >= split_value
  end

  # Other type comparison
  defp compare_for_split?(value, split_value) do
    value == split_value
  end
end
