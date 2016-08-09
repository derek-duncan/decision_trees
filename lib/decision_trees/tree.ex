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
  def build(dataset, target_key) do
    key_values = possible_values(dataset, target_key)
    best_results = Enum.reduce(key_values, %{}, &narrow_values(&1, &2, dataset: dataset, target_key: target_key))

    positive_gain? = best_results[:best_gain] > 0
    if positive_gain? do
      %Tree{
        key: List.first(best_results.best_criteria),
        value: List.last(best_results.best_criteria),
        truthy_tree: build(List.first(best_results.best_sets), target_key),
        falsy_tree: build(List.last(best_results.best_sets), target_key),
      }
    else
      %Tree{results: Counter.unique_values(dataset, target_key)}
    end
  end

  # Finds all the possible values for keys in dataset
  defp possible_values(dataset, exclude_key \\ nil) do
    keys = hd(dataset) |> Keyword.keys |> Enum.reject(&(&1 == exclude_key))
    key_values = Enum.reduce(keys, %{}, fn key, acc ->
      Map.put(acc, key, Enum.reduce(dataset, %{}, fn item, acc ->
        Map.put(acc, item[key], 1)
      end))
    end)
  end

  defp narrow_values({key, values}, acc, [dataset: dataset, target_key: target_key]) do
    results = %{best_gain: 0, best_criteria: [], best_sets: []}
    Enum.reduce values, results, fn {value_key, _}, best ->
      {set1, set2} = Splitter.data(dataset, key, value_key)

      gain = calculate_gain(dataset, set1, set2, target_key)
      if gain > best[:best_gain] do
        best = best
        |> Map.put(:best_gain, gain)
        |> Map.put(:best_criteria, [key, value_key])
        |> Map.put(:best_sets, [set1, set2])
      end
      best
    end
  end

  # Information gain
  defp calculate_gain(dataset, set1, set2, target_key) do
    p = length(set1) / length(dataset)
    [base_e, set1_e, set2_e] = [dataset, set1, set2] |> Enum.map(&Calculate.entropy(&1, target_key))
    gain = base_e - p * set1_e - (1 - p) * set2_e
  end
end
