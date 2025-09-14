defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view

  def mount(_params, session, socket) do
    score = (session["last_score"] || 0)
    top_scores = Tetris.HighScores.top(10)
    {:ok, assign(socket, score: score, top_scores: top_scores)}
  end

  def handle_event("play", _, socket) do
    {:noreply, push_navigate(socket, to: "/game/playing")}
  end

  defp default_name(nil), do: "Anonymous"
  defp default_name(<<>>), do: "Anonymous"
  defp default_name(name), do: String.trim(name)
end
