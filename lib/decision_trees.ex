defmodule DecisionTrees do

  @doc """
  Divide a list into two children lists
  """
  def divide_list(list, split_key, split_value) do
    # Divide the list into two segments
    divided_list = list
    |> Enum.partition(&(decide_split(&1[split_key], split_value)))
    elem(divided_list, 0)
  end

  defp decide_split(value, split_value) when is_number(value) and is_number(split_value), do: value >= split_value
  defp decide_split(value, split_value), do: value == split_value

  @doc """
  Gets the count of values for a specific key
  """
  # def unique_counts(key) do
  #   # Find unique counts
  # end

  @doc """
  Calculates the entropy of a list's values
  """
  # def entropy(list) do
  #   # Calculate entropy
  # end
end
