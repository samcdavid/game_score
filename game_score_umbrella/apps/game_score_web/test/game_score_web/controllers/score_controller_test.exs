defmodule GameScoreWeb.ScoreControllerTest do
  use GameScoreWeb.ConnCase
  use ExUnitProperties

  property "it can add an integer score with or without a note", %{conn: conn} do
    check all(
            all_points <- list_of(integer(), max_length: 100),
            points <- integer(),
            note <- string(:printable)
          ) do
      game_name = Enum.at(StreamData.string(:printable, min_length: 1), 0)
      player_name = Enum.at(StreamData.string(:printable, min_length: 1), 0)
      GameScore.new_game(game_name, player_name)

      Enum.each(all_points, &GameScore.add_player_score(game_name, player_name, &1))

      expected = %{
        "player_name" => player_name,
        "total_score" => Enum.sum(all_points) + points
      }

      response =
        conn
        |> post(
          Routes.score_path(conn, :create, %{
            "game_name" => game_name,
            "player_name" => player_name,
            "points" => points,
            "note" => note
          })
        )
        |> json_response(200)

      assert response == expected
    end
  end
end
