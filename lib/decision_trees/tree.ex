defmodule DecisionTrees.Tree do
  @moduledoc """
  Builds the decision tree
  """

  alias DecisionTrees.Tree, as: Tree

  defstruct key: nil, value: nil, results: nil, truthy_tree: nil, falsy_tree: nil

  @doc """
  Build a tree with the following steps
  - Loop each key except the target key and generate the list of all possible different values in the considered column
  """
  def build([], _), do: %Tree{}

  # TODO: Split this into smaller methods
  def build(dataset, target_key) do
    current_entropy_score = DecisionTrees.Calculate.entropy(dataset, target_key)

    # key_values = %{
    #   :body => %{"aluminum" => 1, "plastic" => 1},
    #   :weight => %{2 => 1, 5 => 1}
    # }
    keys = Keyword.keys(hd(dataset)) # Get the first item's keys as a template
    key_values = Enum.reduce(keys, %{}, fn key, values ->
      Map.put(values, key, Enum.reduce(dataset, %{}, fn item, values ->
        Map.put(values, item[key], 1)
      end))
    end)

    best_results = Enum.reduce key_values, %{}, fn {key, value}, _acc ->
      Enum.reduce value, %{best_gain: 0, best_criteria: [], best_sets: []}, fn {value_key, _}, best ->
        {set1, set2} = DecisionTrees.Splitter.dataset dataset, key, value_key

        # Information gain
        p = length(set1) / length(dataset)
        gain = current_entropy_score - p * DecisionTrees.Calculate.entropy(set1, target_key) - (1 - p) * DecisionTrees.Calculate.entropy(set2, target_key)
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
      %Tree{
        key: List.first(best_results[:best_criteria]),
        value: List.last(best_results[:best_criteria]),
        truthy_tree: build(List.first(best_results[:best_sets]), target_key),
        falsy_tree: build(List.last(best_results[:best_sets]), target_key),
      }
    else
      %Tree{
        results: DecisionTrees.Counter.unique_values(dataset, target_key)
      }
    end
  end

  def print(tree) do
    if tree.results do
      IO.inspect tree.results
    else
      IO.inspect "#{tree.key}: #{tree.value} ?"
      # Print the branches
      IO.inspect "T->"
      IO.inspect tree.truthy_tree
      IO.inspect "F->"
      IO.inspect tree.falsy_tree
    end
  end
end
