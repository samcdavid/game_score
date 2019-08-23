defmodule Fixtures do
  alias GameScore.Core.{Player, Score}

  defmacro __using__(_options) do
    quote do
      alias GameScore.Core.{Player, Score}
      import Fixtures, only: :functions
    end
  end

  def build_score(opts \\ []) do
    points = Keyword.get(opts, :points, Enum.random(-25..100))
    note = Keyword.get(opts, :note)

    %Score{
      points: points,
      note: note
    }
  end

  def build_score_list() do
    notes = ["", "random note", "good note", "bad note"]

    for _ <- 1..Enum.random(2..100), into: [] do
      [note] = Enum.take_random(notes, 1)
      build_score(note: note)
    end
  end

  def build_player(opts \\ []) do
    %Player{
      name: Keyword.get(opts, :name, "Player Name"),
      scores: Keyword.get(opts, :scores, build_score_list())
    }
  end
end
