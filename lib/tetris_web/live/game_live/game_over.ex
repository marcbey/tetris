defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view
  alias Tetris.Game

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(socket, game: Map.get(socket.assigns, :game) || Game.new)
    }
  end

  def handle_event("play", _, socket) do
    {:noreply, push_navigate(socket, to: "/game/playing")}
  end

end
