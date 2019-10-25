defmodule GameScore.Core.Score do
  @moduledoc """
  Provides new/0 and new/1 functions for creating new scores.
  """

  defstruct ~w[points note]a

  @doc """
  Creates a new score entry.

  ## Parameters

    - options: An optional keyword list for specifying the points and note fields on a new score.

  ## Examples

    iex> GameScore.Core.Score.new()
    {:ok, %GameScore.Core.Score{points: 0, note: ""}}

    iex> GameScore.Core.Score.new(points: 23)
    {:ok, %GameScore.Core.Score{points: 23, note: ""}}

    iex> GameScore.Core.Score.new(note: "Team A made a move")
    {:ok, %GameScore.Core.Score{points: 0, note: "Team A made a move"}}

    iex> GameScore.Core.Score.new(points: 5, note: "Team B scored big!")
    {:ok, %GameScore.Core.Score{points: 5, note: "Team B scored big!"}}
  """
  def new(options \\ []) do
    points = Keyword.get(options, :points, 0)
    note = Keyword.get(options, :note, "")
    new_score(points, note)
  end

  defp new_score(points, _note) when not is_number(points) do
    {:error, "points must be a number"}
  end

  defp new_score(_points, note) when not is_binary(note) do
    {:error, "note must be a string"}
  end

  defp new_score(points, note) do
    score = %__MODULE__{
      points: points,
      note: note
    }

    {:ok, score}
  end
end
