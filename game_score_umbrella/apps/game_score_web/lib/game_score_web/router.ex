defmodule GameScoreWeb.Router do
  use GameScoreWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GameScoreWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", GameScoreWeb do
    pipe_through :api
    resources "/game-session", GameSessionController, only: [:create, :delete, :show]
    resources "/player", PlayerController, only: [:create]
  end
end
