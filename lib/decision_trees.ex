defmodule DecisionTrees do
  def seed do
    {:ok, data} = File.read("./lib/sample_dataset.json")
    Poison.decode!(data)
  end

  defdelegate build(dataset, target_key), to: DecisionTrees.Tree
  defdelegate classify(observation, tree), to: DecisionTrees.Classifier
end
