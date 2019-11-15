defmodule GameScoreWeb.GameSessionControllerTest do
  use GameScoreWeb.ConnCase
  use ExUnitProperties

  property "it can create a new game with a non empty game name and player name", %{conn: conn} do
    check all(
            player_name <- string(:printable, min_length: 1),
            game_name <- string(:printable, min_length: 1)
          ) do
      response =
        conn
        |> post(
          Routes.game_session_path(conn, :create, %{
            "game_name" => game_name,
            "player_name" => player_name
          })
        )
        |> json_response(200)

      expected = %{
        "game_name" => game_name,
        "players" => [player_name]
      }

      assert response == expected
    end
  end

  property "it can delete a game that has been created", %{conn: conn} do
    check all(
            game_name <- string(:printable, min_length: 1),
            player_name <- string(:printable, min_length: 1)
          ) do
      GameScore.new_game(game_name, player_name)

      expected = %{
        "message" => "#{game_name} was terminated.",
        "status" => "ok"
      }

      response =
        conn
        |> delete(Routes.game_session_path(conn, :delete, game_name))
        |> json_response(200)

      assert response == expected
    end
  end

  property "it can get a game that exists", %{conn: conn} do
    check all(
            game_name <- string(:printable, min_length: 1),
            player_name <- string(:printable, min_length: 1)
          ) do
      GameScore.new_game(game_name, player_name)

      expected = %{
        player_name => %{
          "name" => player_name,
          "scores" => []
        }
      }

      response =
        conn
        |> get(Routes.game_session_path(conn, :show, game_name))
        |> json_response(200)

      assert response == expected
    end
  end
end
