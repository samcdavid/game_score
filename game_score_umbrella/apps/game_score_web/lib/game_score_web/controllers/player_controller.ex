defmodule GameScoreWeb.PlayerController do
  use GameScoreWeb, :controller

  def create(conn, %{"game_name" => game_name, "player_name" => player_name}) do
    case GameScore.add_player(game_name, player_name) do
      %{} = response ->
        json(conn, response)

      {:error, _} ->
        response = %{
          status: :error,
          message: "You cannot add #{player_name} to #{game_name}"
        }

        conn
        |> put_status(500)
        |> json(response)
    end
  end
end
