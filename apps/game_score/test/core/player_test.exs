defmodule GameScore.Core.PlayerTest do
  use ExUnit.Case
  use ExUnitProperties
  use Fixtures
  use Generators

  doctest Player

  describe "when creating a new player" do
    property "name can be any non-empty string" do
      check all name <- string(:printable) do
        case name do
          "" -> assert {:error, "name cannot be empty"} == Player.new(name)
          _ -> assert {:ok, %Player{name: name, scores: []}} == Player.new(name)
        end
      end
    end

    property "name must be a string" do
      check all name <- term(),
                !is_binary(name) do
        assert Player.new(name) == {:error, "name must be a string"}
      end
    end
  end

  describe "when adding scores" do
    property "it adds the score to the player" do
      check all name <- gen_player_name(),
                scores <- gen_score() do
        {:ok, player} = Player.new(name)

        assert Player.add_score(player, scores) ==
                 %Player{name: name, scores: [scores]}
      end
    end

    property "it adds a new score to the player" do
      check all player <- gen_player(),
                score <- gen_score() do
        updated_player = Player.add_score(player, score)
        assert hd(updated_player.scores) == score
      end
    end
  end

  describe "when computing the total score" do
    property "the total score is 0 if the player doesn't have scores" do
      check all name <- gen_player_name() do
        {:ok, player} = Player.new(name)
        assert Player.total_score(player) == 0
      end
    end

    property "the total score is always a number" do
      check all player <- gen_player() do
        assert is_number(Player.total_score(player))
      end
    end
  end
end
