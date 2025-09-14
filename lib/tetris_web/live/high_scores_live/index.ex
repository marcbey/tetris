defmodule TetrisWeb.HighScoresLive.Index do
  use TetrisWeb, :live_view
  alias Tetris.HighScores

  def mount(_params, _session, socket) do
    {:ok, assign(socket, top_scores: HighScores.top(50))}
  end
end

