defmodule DecisionTrees.Tree do
  @moduledoc """
  Builds the decision tree
  """
  alias DecisionTrees.{Tree, Calculate, Splitter, Counter}

  defstruct key: nil, value: nil, results: nil, truthy_tree: nil, falsy_tree: nil

  @doc """
  Build a tree with the following steps
  - Loop each key except the target key and generate the list of all possible different values in the considered column
  """
  def build([], _target_key), do: %Tree{}
  # TODO: Split this into smaller methods

  def build([head | _] = dataset, target_key) when is_list(head) do
    dataset_map = Enum.into(dataset, [], fn item ->
      Enum.reduce(item, %{}, fn value, values ->
        index = length(Map.keys(values))
        Map.put(values, index, value)
      end)
    end)
    build(dataset_map, target_key)
  end

  def build(dataset_map, target_key) do
    key_values = possible_values(dataset_map, target_key)
    best_results = Enum.reduce(key_values, %{}, &narrow_values(&1, &2, dataset_map: dataset_map, target_key: target_key))

    positive_gain? = best_results[:best_gain] > 0
    if positive_gain? do
      %Tree{
        key: List.first(best_results.best_criteria),
        value: List.last(best_results.best_criteria),
        truthy_tree: build(List.first(best_results.best_sets), target_key),
        falsy_tree: build(List.last(best_results.best_sets), target_key),
      }
    else
      %Tree{results: Counter.unique_values(dataset_map, target_key)}
    end
  end

  # Finds all the possible values for keys in dataset
  defp possible_values(dataset_map, exclude_key) do
    keys = hd(dataset_map) |> Map.keys |> Enum.reject(&(&1 == exclude_key))
    Enum.reduce(keys, %{}, fn key, acc ->
      Map.put(acc, key, Enum.reduce(dataset_map, %{}, fn item, acc ->
        Map.put(acc, item[key], 1)
      end))
    end)
  end

  # Get the best tree results
  defp narrow_values({key, values_map}, _acc, [dataset_map: dataset_map, target_key: target_key]) do
    results = %{best_gain: 0, best_criteria: [], best_sets: []}
    Enum.reduce values_map, results, fn {value, _}, best_results ->
      {set1, set2} = Splitter.data(dataset_map, key, value)

      gain = calculate_gain(dataset_map, set1, set2, target_key)
      if gain > best_results[:best_gain] do
        best_results
        |> Map.put(:best_gain, gain)
        |> Map.put(:best_criteria, [key, value])
        |> Map.put(:best_sets, [set1, set2])
      else
        best_results
      end
    end
  end

  # Information gain
  defp calculate_gain(dataset_map, set1, set2, target_key) do
    p = length(set1) / length(dataset_map)
    [base_e, set1_e, set2_e] = [dataset_map, set1, set2] |> Enum.map(&Calculate.entropy(&1, target_key))
    base_e - p * set1_e - (1 - p) * set2_e
  end
end
