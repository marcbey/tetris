defmodule Tetris.AshRegistry do
  use Ash.Registry, extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry Tetris.HighScores.ScoreResource
  end
end

