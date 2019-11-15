defmodule GameScoreWeb.GameSessionController do
  use GameScoreWeb, :controller

  def create(conn, %{"game_name" => game_name, "player_name" => player_name}) do
    with {:ok, _pid} <- GameScore.new_game(game_name, player_name),
         players <- GameScore.get_player_list(game_name) do
      response = %{
        game_name: game_name,
        players: players
      }

      json(conn, response)
    else
      _ ->
        error_response(
          conn,
          "You must provide a unique game name and a player name to create a new game session."
        )
    end
  end

  def delete(conn, %{"id" => game_name}) do
    case GameScore.end_game(game_name) do
      :ok ->
        response = %{
          status: :ok,
          message: "#{game_name} was terminated."
        }

        json(conn, response)

      _ ->
        error_response(conn, "#{game_name} could not be terminated")
    end
  end

  def show(conn, %{"id" => game_name}) do
    case GameScore.get_game(game_name) do
      %{} = response ->
        json(conn, response)

      {:error, _} ->
        error_response(conn, "#{game_name} could not be found")
    end
  end

  defp error_response(conn, message) do
    response = %{
      status: :error,
      message: message
    }

    conn
    |> put_status(500)
    |> json(response)
  end
end
