defmodule Tetris.AshDomain do
  use Ash.Domain

  resources do
    # You can list resources directly or via a registry
    resource Tetris.HighScores.ScoreResource
  end
end

