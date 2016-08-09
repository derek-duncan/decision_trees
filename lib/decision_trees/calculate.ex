defmodule DecisionTrees.Calculate do
  alias DecisionTrees.Counter

  @doc """
  Calculates the entropy of a dataset's unique values
  """
  def entropy(data, target_key) do
    unique_data = Counter.unique_values(data, target_key)
    # Entropy is the sum of p(x)log(p(x)) across all
    # the different possible results
    Enum.reduce unique_data, 0, fn {_key, value}, sum ->
      p = value / length(data)
      sum - p * log2(p)
    end
  end

  defp log2(input) when input <= 0, do: 0
  defp log2(input) do
    :math.log(input) / :math.log(2)
  end
end
