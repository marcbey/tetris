defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view
  require Logger
  alias Tetris.HighScores

  def mount(_params, session, socket) do
    score = (session["last_score"] || 0)
    player_name = default_name(session["player_name"]) # supports future name passing

    if score > 0 do
      case HighScores.submit(player_name, score) do
        {:ok, _} -> :ok
        {:error, reason} -> Logger.error("Failed to save score: #{inspect(reason)}")
      end
    end

    top_scores = HighScores.top(10)

    {:ok, assign(socket, score: score, top_scores: top_scores)}
  end

  def handle_event("play", _, socket) do
    {:noreply, push_navigate(socket, to: "/game/playing")}
  end

  defp default_name(nil), do: "Anonymous"
  defp default_name(<<>>), do: "Anonymous"
  defp default_name(name), do: String.trim(name)
end
