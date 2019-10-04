defmodule GameScore.Boundary.GameSession do
  alias GameScore.Core.{Game, Player, Score}
  use GenServer

  @moduledoc """
  GameSession allows users to create a new game session with a unique name for
  keeping score of a game they are playing.
  """

  # Public API

  @doc """
  Creates a new GameSession worker.

  ## Parameters

    - game_name: A required, non empty, globally unique name for the game.
    - first_player_name: A required, non empty, unique name for the first player.
  """
  def new_game(game_name, first_player_name) do
    game =
      Game.new()
      |> Game.add_player(first_player_name)

    DynamicSupervisor.start_child(
      GameScore.Supervisor.GameSession,
      {__MODULE__, {game_name, game}}
    )
  end

  @doc """
  Add another player to the game.

  ## Parameters

    - name: A required name tuple for identifying the game.
    - player_name: A unique name for the player being added to the game.
  """
  def add_player(name, player_name) do
    GenServer.call(via(name), {:add_player, player_name})
  end

  @doc """
  Add a score to a player.

  ## Parameters

    - name: A required name tuple for identifying the game.
    - player_name: A unique name for the player being added to the game.
    - points: A number for the points value to attribute to the player.
    - note: A string to note why the points were attributed to the player.
  """
  def add_player_score(name, player_name, points, note) do
    GenServer.call(via(name), {:add_player_score, player_name, points, note})
  end

  @doc """
  Get the current total score for every player in the game.

  ## Parameters

    - name: A required name tuple for identifying the game.
  """
  def get_game_score(name) do
    GenServer.call(via(name), :get_game_score)
  end

  @doc """
  Get the current score breakdown for every player in the game.

  ## Parameters

    - name: A required name tuple for identifying the game.
  """
  def get_game(name) do
    GenServer.call(via(name), :get_game)
  end

  @doc """
  End the current game.

  ## Parameters

    - name: A required name tuple for identifying the game.
  """
  def end_game(name) do
    GenServer.stop(via(name))
  end

  def child_spec({game_name, game}) do
    %{
      id: {__MODULE__, {:game, game_name}},
      start: {__MODULE__, :start_link, [{game_name, game}]},
      restart: :temporary
    }
  end

  def start_link({game_name, game}) do
    GenServer.start_link(
      __MODULE__,
      {game_name, game},
      name: via({:game, game_name})
    )
  end

  # GenServer Implementation

  def init({game_name, game}) do
    {:ok, {game_name, game}}
  end

  def handle_call(:get_game, _, {_game_name, game} = session) do
    {:reply, game, session}
  end

  def handle_call({:add_player, player_name}, _, {game_name, game}) do
    updated_game = Game.add_player(game, player_name)
    {:reply, updated_game, {game_name, updated_game}}
  end

  def handle_call({:add_player_score, player_name, points, note}, _, {game_name, game}) do
    {:ok, score} = Score.new(points: points, note: note)
    player = Player.add_score(game[player_name], score)
    player_total_score = Player.total_score(player)
    updated_game = Map.put(game, player_name, player)

    {
      :reply,
      {"#{player_name} score", player_total_score},
      {game_name, updated_game}
    }
  end

  def handle_call(:get_game_score, _, {_game_name, game} = state) do
    score_map =
      Enum.reduce(game, %{}, fn {player_name, player}, acc ->
        Map.put(acc, player_name, Player.total_score(player))
      end)

    {:reply, score_map, state}
  end

  # Private Functions

  defp via({:game, _game_name} = name) do
    {
      :via,
      Registry,
      {GameScore.Registry.GameSession, name}
    }
  end
end
