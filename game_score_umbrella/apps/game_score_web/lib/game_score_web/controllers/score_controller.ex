defmodule GameScoreWeb.ScoreController do
  use GameScoreWeb, :controller

  def create(
        conn,
        %{
          "game_name" => game_name,
          "player_name" => player_name,
          "points" => points
        } = score
      ) do
    case GameScore.add_player_score(
           game_name,
           player_name,
           to_number(points),
           Map.get(score, "note", "")
         ) do
      {^player_name, total_score} ->
        response = %{
          player_name: player_name,
          total_score: total_score
        }

        json(conn, response)

      {:error, _} ->
        response = %{
          status: :error,
          message: "Could not retrieve the score for #{player_name}"
        }

        conn
        |> put_status(500)
        |> json(response)
    end
  end

  defp to_number(points) when is_integer(points), do: points

  defp to_number(points) when is_binary(points), do: String.to_integer(points)

  defp to_number(_), do: ""
end
