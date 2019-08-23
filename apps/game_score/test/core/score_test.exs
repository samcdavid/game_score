defmodule GameScore.Core.ScoreTest do
  use ExUnit.Case
  use ExUnitProperties

  alias GameScore.Core.Score

  doctest Score

  property "it always takes points and a note" do
    check all points <- integer(),
              floats <- float(),
              note <- binary() do
      assert Score.new(points: points, note: note) ==
               {:ok, %Score{points: points, note: note}}

      assert Score.new(points: floats, note: note) ==
               {:ok, %Score{points: floats, note: note}}
    end
  end

  property "it always defaults points to 0" do
    check all note <- binary() do
      assert Score.new(note: note) == {:ok, %Score{points: 0, note: note}}
    end
  end

  property "it always defaults note to an empty string" do
    check all points <- integer() do
      assert Score.new(points: points) == {:ok, %Score{points: points, note: ""}}
    end
  end

  property "it returns an error if the points value supplied is not a number" do
    check all string <- string(:printable) do
      assert Score.new(points: string) == {:error, "points must be a number"}
    end
  end

  property "it returns an error if the note value supplied is not a string" do
    check all integers <- integer() do
      assert Score.new(note: integers) == {:error, "note must be a string"}
    end
  end
end
