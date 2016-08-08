defmodule DecisionTrees do
  def seed do
    items = [
      [body: "aluminum", weight: 2, color: "gray"],
      [body: "plastic", weight: 4, color: "black"],
      [body: "plastic", weight: 2, color: "gray"],
      [body: "aluminum", weight: 5, color: "red"],
      [body: "plastic", weight: 1, color: "white"],
    ]
  end

  defdelegate build(dataset, target_key), to: DecisionTrees.Tree
  defdelegate print(tree), to: DecisionTrees.Tree
  defdelegate classify(observation, tree), to: DecisionTrees.Classifier
end
