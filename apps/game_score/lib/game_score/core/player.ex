defmodule GameScore.Core.Player do
  alias GameScore.Core.Score

  @moduledoc """
  Player keeps tracker of a player name and a list of scores.
  """
  defstruct ~w[name scores]a

  @doc """
  Creates a new player for keeping track of scores.

  ## Parameters

    - name: A required and non empty string for the name of the player or team

  ## Examples

    iex> GameScore.Core.Player.new("bob")
    {:ok, %GameScore.Core.Player{name: "bob", scores: []}}

    iex> GameScore.Core.Player.new("Team 1")
    {:ok, %GameScore.Core.Player{name: "Team 1", scores: []}}

    iex> GameScore.Core.Player.new(nil)
    {:error, "name cannot be nil"}

    iex> GameScore.Core.Player.new("")
    {:error, "name cannot be empty"}
  """
  def new(name) when is_nil(name) do
    {:error, "name cannot be nil"}
  end

  def new(name) when is_binary(name) do
    player = %__MODULE__{
      name: name,
      scores: []
    }

    case name do
      "" -> {:error, "name cannot be empty"}
      _ -> {:ok, player}
    end
  end

  def new(_name) do
    {:error, "name must be a string"}
  end

  @doc """
  Add a new score entry to a player.

  ## Parameters

    - player: GameScore.Core.Player.t() the player that you want to add the score to.
    - score: GameScore.Core.Score.t() the score entry to add to the player.

  ## Examples

    iex> alias GameScore.Core.{Player, Score}
    iex> {:ok, player} = Player.new("Team A")
    iex> {:ok, score1} = Score.new(points: 5, note: "round 1")
    iex> Player.add_score(player, score1)
    %Player{name: "Team A", scores: [%Score{points: 5, note: "round 1"}]}
  """
  def add_score(player = %__MODULE__{}, score = %Score{}) do
    %{player | scores: [score | player.scores]}
  end

  @doc """
  Compute the total score for a player.

  ## Parameters

    - player: GameScore.Core.Player.t() the player that you want to calculate the score for.

  ## Examples

    iex> alias GameScore.Core.{Player, Score}
    iex> {:ok, player} = Player.new("Team A")
    iex> {:ok, score1} = Score.new(points: 5, note: "round 1")
    iex> {:ok, score2} = Score.new(points: 15, note: "")
    iex> {:ok, score3} = Score.new(points: 25, note: "bonus")
    iex> player = Player.add_score(player, score1)
    iex> player = Player.add_score(player, score2)
    iex> player = Player.add_score(player, score3)
    iex> Player.total_score(player)
    45
  """
  def total_score(%__MODULE__{scores: scores}) do
    Enum.reduce(scores, 0, fn score, total -> total + score.points end)
  end
end
