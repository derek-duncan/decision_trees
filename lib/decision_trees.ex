defmodule DecisionTrees do
  def seed do
    [
      [
        father_figure: true,
        college: true,
        income_level: 1,
        gender: "male",
      ],
      [
        father_figure: false,
        college: false,
        income_level: 3,
        gender: "female",
      ],
      [
        father_figure: true,
        college: true,
        income_level: 1,
        gender: "female",
      ],
      [
        father_figure: false,
        college: false,
        income_level: 2,
        gender: "male",
      ],
      [
        father_figure: false,
        college: true,
        income_level: 2,
        gender: "female",
      ],
      [
        father_figure: true,
        college: false,
        income_level: 3,
        gender: "male",
      ],
    ]
  end

  defdelegate build(dataset, target_key), to: DecisionTrees.Tree
  defdelegate classify(observation, tree), to: DecisionTrees.Classifier
end
