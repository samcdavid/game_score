defmodule GameScore.Core.Game do
  @moduledoc """
  Module for creating a game and managing the players in a game. The data
  structure for games is a Map where the player names are the keys and the
  value is the player struct for that player.
  """

  @doc """
  Start a new game.

  ## Parameters

    - none

  ## Examples

    iex> GameScore.Core.Game.new()
    %{}
  """
  def new(), do: %{}

  @doc """
  Add a player to the game. This can be done by providing a string for the
  player name or a GameScore.Core.Player struct.

  ## Parameters

    - game: map for representing the game
    - player: string or GameScore.Core.Player struct to be added to the game.

  ## Examples

    iex> GameScore.Core.Game.add_player(%{}, "Sam")
    %{"Sam" => %GameScore.Core.Player{name: "Sam", scores: []}}

    iex> player = %GameScore.Core.Player{name: "Team Joe", scores: []}
    iex> GameScore.Core.Game.add_player(%{}, player)
    %{"Team Joe" => %GameScore.Core.Player{name: "Team Joe", scores: []}}
  """
  def add_player(%{} = game, name) when is_binary(name) do
    {:ok, player} = GameScore.Core.Player.new(name)
    add_player(game, player)
  end

  def add_player(%{} = game, %GameScore.Core.Player{} = player) do
    case Map.get(game, player.name) do
      nil -> Map.put(game, player.name, player)
      _ -> {:error, "player already exists"}
    end
  end
end
