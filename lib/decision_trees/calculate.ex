defmodule DecisionTrees.Calculate do
  alias DecisionTrees.Counter

  @doc """
  Calculates the entropy of a dataset's unique values
  """
  def entropy(dataset, target_key) do
    unique_dataset = Counter.unique_values(dataset, target_key)
    # Entropy is the sum of p(x)log(p(x)) across all
    # the different possible results
    Enum.reduce unique_dataset, 0, fn {_key, value}, sum ->
      p = value / length(dataset)
      sum - p * log2(p)
    end
  end

  defp log2(input) do
    :math.log(input) / :math.log(2)
  end
end
