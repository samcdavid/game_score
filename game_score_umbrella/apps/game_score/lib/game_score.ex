defmodule GameScore do
  alias GameScore.Boundary.GameSession

  @moduledoc """
  GameScore allows a user to keep score of any type of game they may be playing.
  This is especially useful for card games and board games. Each game must be
  created with a unique name and the name of the first player/team. Once the game
  is created new players can be easily added. Then scores may be added to each
  player.

  An overall game state is not kept so that new players can be added to the score
  list at any time. This makes it easy for new players to join in the middle of
  your game and start tracking their scores.
  """

  @doc """
  Create a new GameScore.

  ## Parameters

    - game_name: A unique string that is the name of the game.
    - first_player_name: The string name of the first player or team.
  """
  def new_game(game_name, first_player_name) do
    GameSession.new_game(game_name, first_player_name)
  end

  @doc """
  Add a player to the game.

  ## Parameters

    - game_name: A unique string that is the name of the game.
    - player_name: The string name of the player or team.
  """
  def add_player(game_name, player_name) do
    fun = fn ->
      game_name
      |> name_tuple()
      |> GameSession.add_player(player_name)
    end

    if_game_exists(game_name, fun)
  end

  @doc """
  Add a score to a player or team.

  ## Parameters

    - game_name: A unique string that is the name of the game.
    - player_name: The string name of the player or team.
    - points: A number representing the number of points for this score.
    - note: An optional string to add meta data to the score.
  """
  def add_player_score(game_name, player_name, points, note \\ "") do
    fun = fn ->
      game_name
      |> name_tuple()
      |> GameSession.add_player_score(player_name, points, note)
    end

    if_game_exists(game_name, fun)
  end

  @doc """
  Get the total game score.

  ## Parameters

    - game_name: A unique string that is the name of the game.
  """
  def get_game_score(game_name) do
    fun = fn ->
      game_name
      |> name_tuple()
      |> GameSession.get_game_score()
    end

    if_game_exists(game_name, fun)
  end

  @doc """
  Get a map representing the entire state of the game.

  ## Parameters

    - game_name: A unique string that is the name of the game.
  """
  def get_game(game_name) do
    fun = fn ->
      game_name
      |> name_tuple()
      |> GameSession.get_game()
    end

    if_game_exists(game_name, fun)
  end

  @doc """
  End a game.

  ## Parameters

    - game_name: A unique string that is the name of the game.
  """
  def end_game(game_name) do
    fun = fn ->
      game_name
      |> name_tuple()
      |> GameSession.end_game()
    end

    if_game_exists(game_name, fun)
  end

  defp name_tuple(name), do: {:game, name}

  defp if_game_exists(game_name, fun) do
    process_name = name_tuple(game_name)
    process_list = Registry.lookup(GameScore.Registry.GameSession, process_name)

    case Enum.empty?(process_list) do
      true -> {:error, "#{game_name} could not be found."}
      _ -> fun.()
    end
  end
end
