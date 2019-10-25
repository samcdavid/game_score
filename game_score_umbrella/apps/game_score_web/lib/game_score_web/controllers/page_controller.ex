defmodule GameScoreWeb.PageController do
  use GameScoreWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
