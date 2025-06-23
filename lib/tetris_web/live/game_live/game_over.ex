defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view

  def mount(params, _session, socket) do
    {
      :ok,
      assign(socket, score: params["score"] || 0)
    }
  end

  def handle_event("play", _, socket) do
    {:noreply, push_navigate(socket, to: "/game/playing")}
  end

end
