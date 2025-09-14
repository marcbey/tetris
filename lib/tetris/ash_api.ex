defmodule Tetris.AshApi do
  use Ash.Api

  resources do
    registry Tetris.AshRegistry
  end
end

