defmodule Generators do
  use ExUnitProperties

  defmacro __using__(_options) do
    quote do
      import Generators, only: :functions
    end
  end

  def gen_player() do
    gen all name <- gen_player_name(),
            scores <- list_of(gen_score(), max_length: 100) do
      %GameScore.Core.Player{name: name, scores: scores}
    end
  end

  def gen_player_name() do
    gen all name <- string(:printable),
            String.trim(name) != "" do
      name
    end
  end

  def gen_score() do
    gen all points <- integer(),
            note <- string(:printable) do
      %GameScore.Core.Score{points: points, note: note}
    end
  end
end
