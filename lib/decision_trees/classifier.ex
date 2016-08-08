defmodule DecisionTrees.Classifier do
  # TODO: Terrible code. Refactor :)
  def classify(observation, tree) do
    if tree.results do
      tree.results
    else
      value = observation[tree.key]
      branch = None
      if is_number(value) do
        if value >= tree.value do
          branch = tree.truthy_tree
        else
          branch = tree.falsy_tree
        end
      else
        if value == tree.value do
          branch = tree.truthy_tree
        else
          branch = tree.falsy_tree
        end
      end
      classify(observation, branch)
    end
  end
end
