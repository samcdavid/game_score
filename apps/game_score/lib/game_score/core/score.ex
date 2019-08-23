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
    %GameScore.Core.Score{points: 0, note: ""}

    iex> GameScore.Core.Score.new(points: 23)
    %GameScore.Core.Score{points: 23, note: ""}

    iex> GameScore.Core.Score.new(note: "Team A made a move")
    %GameScore.Core.Score{points: 0, note: "Team A made a move"}

    iex> GameScore.Core.Score.new(points: 5, note: "Team B scored big!")
    %GameScore.Core.Score{points: 5, note: "Team B scored big!"}
  """
  def new(options \\ []) do
    %__MODULE__{
      points: Keyword.get(options, :points, 0),
      note: Keyword.get(options, :note, "")
    }
  end
end
