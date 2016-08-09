defmodule DecisionTrees.Classifier do
  def classify(observation, %{results: nil} = tree) do
    target_value = observation[tree.key]
    branch = if is_number(target_value) do
      if target_value >= tree.value, do: tree.truthy_tree, else: tree.falsy_tree
    else
      if target_value == tree.value, do: tree.truthy_tree, else: tree.falsy_tree
    end
    classify(observation, branch)
  end
  def classify(_, %{results: results}), do: results
end
