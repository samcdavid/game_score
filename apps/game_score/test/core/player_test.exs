defmodule GameScore.Core.PlayerTest do
  use ExUnit.Case
  use ExUnitProperties
  use Fixtures

  doctest Player

  describe "when creating a new player" do
    property "name can be any non-empty string" do
      check all name <- string(:printable, min_length: 1) do
        assert Player.new(name) == {:ok, %Player{name: name, scores: []}}
      end
    end

    property "name mus be a string" do
      check all name <- integer() do
        assert Player.new(name) == {:error, "name must be a string"}
      end
    end
  end

  describe "when adding scores" do
    setup do
      score_generator =
        gen all points <- integer(),
                note <- string(:printable) do
          %Score{points: points, note: note}
        end

      {:ok, %{score_generator: score_generator}}
    end

    property "it adds the score to the player", %{score_generator: score_generator} do
      check all name <- string(:printable, min_length: 1),
                scores <- score_generator do
        {:ok, player} = Player.new(name)

        assert Player.add_score(player, scores) ==
                 %Player{name: name, scores: [scores]}
      end
    end

    property "it adds a new score to the player", %{score_generator: score_generator} do
      player = build_player()

      check all score <- score_generator do
        updated_player = Player.add_score(player, score)
        assert hd(updated_player.scores) == score
      end
    end
  end

  describe "when computing the total score" do
    property "the total score is 0 if the player doesn't have scores" do
      check all name <- string(:printable, min_length: 1) do
        {:ok, player} = Player.new(name)
        assert Player.total_score(player) == 0
      end
    end

    property "the total score is always a number" do
      check all name <- string(:printable),
                String.trim(name) != "" do
        player = build_player(name: name)
        assert is_number(Player.total_score(player))
      end
    end
  end
end
