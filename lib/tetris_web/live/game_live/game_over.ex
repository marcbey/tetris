defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view
  alias Tetris.HighScores

  def mount(params, _session, socket) do
    score = parse_score(params["score"]) || 0
    player_name = default_name(params["player"]) # supports future name passing

    if score > 0 do
      _ = HighScores.submit(player_name, score)
    end

    top_scores = HighScores.top(10)

    {:ok, assign(socket, score: score, top_scores: top_scores)}
  end

  def handle_event("play", _, socket) do
    {:noreply, push_navigate(socket, to: "/game/playing")}
  end

  defp parse_score(nil), do: nil
  defp parse_score(<<>>), do: nil
  defp parse_score(val) when is_binary(val) do
    case Integer.parse(val) do
      {int, _} -> int
      :error -> 0
    end
  end

  defp default_name(nil), do: "Anonymous"
  defp default_name(<<>>), do: "Anonymous"
  defp default_name(name), do: String.trim(name)
end
