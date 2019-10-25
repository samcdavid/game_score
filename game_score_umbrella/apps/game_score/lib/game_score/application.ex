defmodule GameScore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {
        Registry,
        [name: GameScore.Registry.GameSession, keys: :unique]
      },
      {
        DynamicSupervisor,
        [name: GameScore.Supervisor.GameSession, strategy: :one_for_one]
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: GameScore.Supervisor)
  end
end
