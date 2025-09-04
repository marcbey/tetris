defmodule TetrisWeb.GameLive.Playing do
  use TetrisWeb, :live_view
  alias Tetris.Game

  @rotate_keys ["ArrowUp", " "]
  @tick_rate 200
  @tick_rate_fast 20

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, @tick_rate)
    end

    socket = new_game(socket)

    # Start background music when game starts
    if connected?(socket) do
      socket = push_event(socket, "tetris-start-music", %{})
      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  defp render_board(assigns) do
    ~H"""
    <svg width="204" height="404" style="background:#222; border:1px solid #444;">
      <defs>
        <linearGradient id="block-gradient" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="#fff" stop-opacity="0.5" />
          <stop offset="100%" stop-color="#000" stop-opacity="0.1" />
        </linearGradient>
      </defs>
      <rect width="200" height="400" x="1" y="1" fill="none" />
      {render_points(assigns)}
    </svg>
    """
  end

  defp render_points(assigns) do
    ~H"""
    <%= for {x, y, shape} <- @game.points ++ Game.junkyard_points(@game) do %>
      <g>
        <rect
          width="20"
          height="20"
          x={(x - 1) * 20 + 1}
          y={(y - 1) * 20 + 1}
          fill={color(shape)}
          stroke="black"
          stroke-width="1"
        />
        <rect
          width="20"
          height="8"
          x={(x - 1) * 20 + 1}
          y={(y - 1) * 20 + 1}
          fill="url(#block-gradient)"
          pointer-events="none"
        />
      </g>
    <% end %>
    """
  end

  defp color(:l), do: "#FF8000"
  defp color(:j), do: "#0000F0"
  defp color(:s), do: "#00F000"
  defp color(:z), do: "#F00000"
  defp color(:o), do: "#F0F000"
  defp color(:i), do: "#00F0F0"
  defp color(:t), do: "#A000F0"
  defp color(_), do: "#888888"

  defp new_game(socket) do
    assign(socket, game: Game.new(), tick_rate: 200)
  end

  def rotate(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(game: Game.rotate(game))
    |> push_event("tetris-rotate", %{})
  end

  def left(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(game: Game.left(game))
    |> push_event("tetris-move", %{})
  end

  def right(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(game: Game.right(game))
    |> push_event("tetris-move", %{})
  end

  def down(%{assigns: %{game: game}} = socket) do
    old_game = game
    new_game = Game.down(game)

    socket = assign(socket, game: new_game)

    # Check if piece merged (dropped)
    socket =
      if old_game.tetro != new_game.tetro do
        push_event(socket, "tetris-drop", %{})
      else
        socket
      end

    # Check for line clears
    socket =
      if new_game.lines_cleared > 0 do
        push_event(socket, "tetris-line-clear", %{lines: new_game.lines_cleared})
      else
        socket
      end

    socket
  end

  def maybe_end_game(%{assigns: %{game: %{game_over: true}}} = socket) do
    socket
    |> push_event("tetris-stop-music", %{})
    |> push_event("tetris-game-over", %{})
    |> push_navigate(to: "/game/over?score=#{socket.assigns.game.score}")
  end

  def maybe_end_game(socket), do: socket

  def handle_info(:tick, socket) do
    socket = socket |> down |> maybe_end_game
    Process.send_after(self(), :tick, socket.assigns.tick_rate)
    {:noreply, socket}
  end

  def handle_event("keydown", %{"key" => key}, socket) when key in @rotate_keys do
    {:noreply, socket |> rotate}
  end

  def handle_event("keydown", %{"key" => "ArrowRight"}, socket) do
    {:noreply, socket |> right}
  end

  def handle_event("keydown", %{"key" => "ArrowLeft"}, socket) do
    IO.inspect(socket)
    {:noreply, socket |> left}
  end

  def handle_event("keydown", %{"key" => "ArrowDown"}, socket) do
    {:noreply, assign(socket, tick_rate: @tick_rate_fast)}
  end

  def handle_event("keyup", %{"key" => "ArrowDown"}, socket) do
    {:noreply, assign(socket, tick_rate: @tick_rate)}
  end

  def handle_event("keydown", %{"key" => "a"}, socket) do
    {:noreply, assign(socket, tick_rate: 2000)}
  end

  def handle_event("keyup", %{"key" => "a"}, socket) do
    {:noreply, assign(socket, tick_rate: @tick_rate)}
  end

  def handle_event("keydown", %{"key" => _}, socket) do
    {:noreply, socket}
  end

  def handle_event("keyup", %{"key" => _}, socket) do
    {:noreply, socket}
  end
end
