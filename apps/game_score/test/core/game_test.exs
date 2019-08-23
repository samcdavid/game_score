defmodule GameScore.Core.GameTest do
  use ExUnit.Case
  use ExUnitProperties
  use Fixtures

  doctest Game

  property "it does not let you add the same player twice" do
    check all name <- string(:printable),
              String.trim(name) !== "" do
      player = build_player(name: name)

      game =
        Game.new()
        |> Game.add_player(player)

      assert %{name => player} == game
      assert {:error, "player already exists"} == Game.add_player(game, name)
    end
  end

  property "new players can be a string or GameScore.Core.Player struct" do
    check all name <- string(:printable),
              String.trim(name) !== "" do
      player = build_player(name: name)

      game =
        Game.new()
        |> Game.add_player(player)

      assert %{name => player} == game

      name2 = "#{name}2"
      updated_game = Game.add_player(game, name2)
      {:ok, player2} = Player.new(name2)

      assert %{name => player, name2 => player2} == updated_game
    end
  end
end
