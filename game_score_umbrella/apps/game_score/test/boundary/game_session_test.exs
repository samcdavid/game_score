defmodule GameScore.Boundary.GameSessionTest do
  use ExUnit.Case
  use Generators

  doctest GameSession

  test "it returns a map with each player and their score history" do
    [player1_name, player2_name] = Enum.take(gen_player_name(), 2)
    game_name = Enum.at(gen_game_name(), 0)
    [score1, score2, score3, score4] = Enum.take(gen_score(), 4)
    name = {:game, game_name}

    {:ok, player1} = Player.new(player1_name)
    {:ok, player2} = Player.new(player2_name)

    added_player = %{
      :players => [player2_name, player1_name],
      player1_name => player1,
      player2_name => player2
    }

    player1 = Player.add_score(player1, score1)
    player1_first_score = {player1_name, score1.points}
    player1 = Player.add_score(player1, score3)
    player1_second_score = {player1_name, score1.points + score3.points}

    player2 = Player.add_score(player2, score2)
    player2_first_score = {player2_name, score2.points}
    player2 = Player.add_score(player2, score4)
    player2_second_score = {player2_name, score2.points + score4.points}

    scores = %{
      player1_name => score1.points + score3.points,
      player2_name => score2.points + score4.points
    }

    game = %{
      :players => [player2_name, player1_name],
      player1_name => player1,
      player2_name => player2
    }

    assert {:ok, _} = GameSession.new_game(game_name, player1_name)
    assert added_player == GameSession.add_player(name, player2_name)

    assert player1_first_score ==
             GameSession.add_player_score(name, player1_name, score1.points, score1.note)

    assert player2_first_score ==
             GameSession.add_player_score(name, player2_name, score2.points, score2.note)

    assert player1_second_score ==
             GameSession.add_player_score(name, player1_name, score3.points, score3.note)

    assert player2_second_score ==
             GameSession.add_player_score(name, player2_name, score4.points, score4.note)

    assert scores == GameSession.get_game_score(name)
    assert game == GameSession.get_game(name)

    assert :ok == GameSession.end_game(name)
  end
end
