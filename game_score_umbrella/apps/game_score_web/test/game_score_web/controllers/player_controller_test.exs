defmodule GameScoreWeb.PlayerControllerTest do
  use GameScoreWeb.ConnCase
  use ExUnitProperties

  test "it can add a player with a non empty name to an existing game", %{conn: conn} do
    game_name = Enum.at(StreamData.string(:printable, min_length: 1), 0)
    player1_name = Enum.at(StreamData.string(:printable, min_length: 1), 0)
    player2_name = Enum.at(StreamData.string(:printable, min_length: 1), 0)
    GameScore.new_game(game_name, player1_name)

    expected = %{
      player1_name => %{
        "name" => player1_name,
        "scores" => []
      },
      player2_name => %{
        "name" => player2_name,
        "scores" => []
      }
    }

    response =
      conn
      |> post(
        Routes.player_path(conn, :create, %{
          "game_name" => game_name,
          "player_name" => player2_name
        })
      )
      |> json_response(200)

    assert response == expected
  end
end
