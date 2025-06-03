defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.{Tetromino, Game}

  @impl true
  def mount(_params, _session, socket) do
    # :timer.send_interval(500, :tick)
    {:ok, socket |> new_game}
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, socket |> down}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="phx-hero">
      <div phx-window-keydown="keystroke">
        <h>Welcome to Tetris!</h>
        <%= render_board(assigns) %>
        <pre>
          <%= inspect(@game.tetro) %>
        </pre>
      </div>
    </section>
    """
  end

  def down(%{assigns: %{tetro: %{location: {_, 20}}}} = socket) do
    socket |> new_tetromino
  end


  def down(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end


  def rotate(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.rotate(tetro))
  end

  def left(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.left(tetro))
  end

  def right(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.right(tetro))
  end


  defp render_board(assigns) do
    ~H"""
    <svg width="200" height="400">
      <rect width="200" height="400" fill="black" />
      <%= render_points(assigns) %>
    </svg>
    """
  end

  defp render_points(assigns) do
    ~H"""
    <%= for {x, y, shape} <- @game.points do %>
      <rect width="20" height="20" x={(x - 1) * 20} y={(y - 1) * 20} fill={color(shape)} />
    <% end %>
    """
  end

  defp color(:l), do: "blue"
  defp color(:j), do: "orange"
  defp color(:s), do: "yellow"
  defp color(:z), do: "green"
  defp color(:o), do: "red"
  defp color(:i), do: "limegreen"
  defp color(:t), do: "magenta"
  defp color(_),  do: "olive"

  defp new_game(socket) do
    assign(socket, game: Game.new())
  end

  defp new_tetromino(socket) do
    assign(socket, game: Game.new_tetromino(socket.assigns.game))
  end

  @impl true
  def handle_event("keystroke", %{"key" => " "}, socket) do
    {:noreply, socket |> rotate}
  end

  def handle_event("keystroke", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, socket |> left}
  end

  def handle_event("keystroke", %{"key" => "ArrowRight"}, socket) do
    {:noreply, socket |> right}
  end

    def handle_event("keystroke", _, socket) do
    {:noreply, socket}
  end
end
