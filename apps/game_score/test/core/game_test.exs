defmodule GameScore.Core.GameTest do
  use ExUnit.Case
  use ExUnitProperties
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
    check all [player1, player2] <- list_of(gen_player(), length: 2) do
      %{name: name1} = player1
      %{name: name2} = player2

      game =
        Game.new()
        |> Game.add_player(player1)

      assert %{name1 => player1} == game

      updated_game = Game.add_player(game, name2)

      assert %{name1 => player1, name2 => %Player{name: name2, scores: []}} ==
               updated_game
    end
  end
end
