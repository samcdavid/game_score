defmodule GameScore.Core.GameTest do
  use ExUnit.Case
  use ExUnitProperties
  use Fixtures
  use Generators

  doctest Game

  property "it does not let you add the same player twice" do
    check all player <- gen_player() do
      %Player{name: name} = player

      game =
        Game.new()
        |> Game.add_player(player)

      assert %{name => player} == game
      assert {:error, "player already exists"} == Game.add_player(game, name)
    end
  end

  property "new players can be a string or GameScore.Core.Player struct" do
    check all [name1, name2] <- list_of(gen_player_name(), length: 2) do
      player = build_player(name: name1)

      game =
        Game.new()
        |> Game.add_player(player)

      assert %{name1 => player} == game

      updated_game = Game.add_player(game, name2)
      {:ok, player2} = Player.new(name2)

      assert %{name1 => player, name2 => player2} == updated_game
    end
  end
end
