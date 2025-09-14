defmodule TetrisWeb.GameLive.Welcome do
  use TetrisWeb, :live_view
  alias Tetris.Game

  def mount(_params, _session, socket) do
    form = to_form(%{"player_name" => ""}, as: :player)

    {:ok,
     assign(socket,
       game: Map.get(socket.assigns, :game) || Game.new(),
       form: form
     )}
  end

  # Form submission now handled by controller; keep validate for client-side echo if needed
  def handle_event("validate", %{"player" => player_params}, socket) do
    {:noreply, assign(socket, form: to_form(player_params, as: :player))}
  end
end
