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

  def handle_event("validate", %{"player" => player_params}, socket) do
    {:noreply, assign(socket, form: to_form(player_params, as: :player))}
  end

  def handle_event("play", %{"player" => %{"player_name" => player_name}}, socket) do
    name = String.trim(player_name || "")

    if name == "" do
      {:noreply, put_flash(socket, :error, "Please enter your name to continue")}
    else
      {:noreply, push_navigate(socket, to: "/game/playing?player=#{URI.encode(name)}")}
    end
  end
end
