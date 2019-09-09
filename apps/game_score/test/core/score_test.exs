defmodule GameScore.Core.ScoreTest do
  use ExUnit.Case
  use ExUnitProperties

  alias GameScore.Core.Score

  doctest Score

  property "it always takes points and a note" do
    check all points <- integer(),
              floats <- float(),
              note <- binary() do
      assert {:ok, %Score{points: points, note: note}} ==
               Score.new(points: points, note: note)

      assert {:ok, %Score{points: floats, note: note}} ==
               Score.new(points: floats, note: note)
    end
  end

  property "it always defaults points to 0" do
    check all note <- binary() do
      assert {:ok, %Score{points: 0, note: note}} == Score.new(note: note)
    end
  end

  property "it always defaults note to an empty string" do
    check all points <- integer() do
      assert {:ok, %Score{points: points, note: ""}} ==
               Score.new(points: points)
    end
  end

  property "it returns an error if the points value supplied is not a number" do
    check all string <- string(:printable) do
      assert {:error, "points must be a number"} == Score.new(points: string)
    end
  end

  property "it returns an error if the note value supplied is not a string" do
    check all integers <- integer() do
      assert {:error, "note must be a string"} == Score.new(note: integers)
    end
  end
end
