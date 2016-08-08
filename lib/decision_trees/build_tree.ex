defmodule DecisionTrees.BuildTree do
  @moduledoc """
  Builds the decision tree
  """

  alias DecisionTrees.BuildTree, as: BuildTree

  defstruct key: nil, value: nil, results: nil, truthy_tree: nil, falsy_tree: nil

  @doc """
  Build a tree with the following steps
  - Loop each key except the target key and generate the list of all possible different values in the considered column
  """
  def build_tree([]), do: %BuildTree{}
  def build_tree(items) do
    current_entropy_score = DecisionTrees.entropy(items, :weight)

    # key_values = %{
    #   :body => %{"aluminum" => 1, "plastic" => 1},
    #   :weight => %{2 => 1, 5 => 1}
    # }
    keys = Keyword.keys(hd(items)) # Get the first item's keys as a template
    key_values = Enum.reduce(keys, %{}, fn key, values ->
      Map.put(values, key, Enum.reduce(items, %{}, fn item, values ->
        Map.put(values, item[key], 1)
      end))
    end)

    best_results = Enum.reduce key_values, %{}, fn {key, value}, _acc ->
      Enum.reduce value, %{best_gain: 0, best_criteria: [], best_sets: []}, fn {value_key, _}, best ->
        {set1, set2} = DecisionTrees.divide_items items, key, value_key

        # Information gain
        p = length(set1) / length(items)
        gain = current_entropy_score - p * DecisionTrees.entropy(set1, :weight) - (1 - p) * DecisionTrees.entropy(set2, :weight)
        if gain > best[:best_gain] and length(set1) > 0 and length(set2) > 0 do
          best = best
          |> Map.put(:best_gain, gain)
          |> Map.put(:best_criteria, [key, value_key])
          |> Map.put(:best_sets, [set1, set2])
        end
        best
      end
    end

    if best_results[:best_gain] > 0 do
      %BuildTree{
        key: List.first(best_results[:best_criteria]),
        value: List.last(best_results[:best_criteria]),
        truthy_tree: build_tree(List.first(best_results[:best_sets])),
        falsy_tree: build_tree(List.last(best_results[:best_sets])),
      }
    else
      %BuildTree{
        results: DecisionTrees.unique_counts(items, :weight)
      }
    end
  end
end
