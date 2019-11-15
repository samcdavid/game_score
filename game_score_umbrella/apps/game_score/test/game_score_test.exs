defmodule GameScoreTest do
  use ExUnit.Case
  use Generators

  doctest GameScore

  test "it can start a new game" do
    game_name = Enum.at(gen_game_name(), 0)
    player_name = Enum.at(gen_player_name(), 0)
    assert {:ok, _pid} = GameScore.new_game(game_name, player_name)
  end

  test "it can add a new player" do
    {game_name, _} = new_game_fixture()
    new_player_name = Enum.at(gen_player_name(), 3)

    result = GameScore.add_player(game_name, new_player_name)
    expected = %{name: new_player_name, scores: []}

    assert {:ok, expected} == Map.fetch(result, new_player_name)
  end

  test "it can add points to a player" do
    {game_name, player_name} = new_game_fixture()
    score = Enum.at(gen_score(), 1)

    result = GameScore.add_player_score(game_name, player_name, score.points, score.note)

    assert {player_name, score.points} == result
  end

  test "it can get the score" do
    {game_name, player_name, total_score} = game_with_points_fixture()

    result = GameScore.get_game_score(game_name)

    assert {:ok, total_score} == Map.fetch(result, player_name)
  end

  test "it can get the game" do
    {game_name, player_name} = new_game_fixture()

    GameScore.add_player_score(game_name, player_name, 10)
    result = GameScore.get_game(game_name)

    expected = %{
      player_name => %{name: player_name, scores: [%{points: 10, note: ""}]}
    }

    assert expected == result
  end

  test "it can get the list of players" do
    {game_name, player_name} = new_game_fixture()

    result = GameScore.get_player_list(game_name)

    expected = [player_name]

    assert expected == result
  end

  test "it can end the game" do
    {game_name, _} = new_game_fixture()

    assert :ok = GameScore.end_game(game_name)
  end

  defp new_game_fixture() do
    game_name = Enum.at(gen_game_name(), 0)
    player_name = Enum.at(gen_player_name(), 0)

    {:ok, _} = GameScore.new_game(game_name, player_name)

    {game_name, player_name}
  end

  defp game_with_points_fixture() do
    {game_name, player_name} = new_game_fixture()
    points = Enum.take(StreamData.integer(), 3)
    total_score = Enum.sum(points)

    Enum.each(points, fn point ->
      GameScore.add_player_score(game_name, player_name, point)
    end)

    {game_name, player_name, total_score}
  end
end
