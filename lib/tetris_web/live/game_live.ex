defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino

  @impl true
  def mount(_params, _session, socket) do
    :timer.send_interval(500, :tick)
    {:ok, socket |> new_tetromino |> show_points()}
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, socket |> down |> show_points}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <% [{x, y}] = @points %>
      <section class="phx-hero">
        <h>Welcome to Tetris!</h>
        <%= render_board(assigns) %>
        <pre>
          <%= "{" %> <%= x %>, <%= y %> <%= "}" %>
        </pre>
      </section>
    """
  end

  def down(%{assigns: %{tetro: %{location: {_, 20}}}} = socket) do
    socket |> new_tetromino |> show_points
  end


  def down(%{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.down(tetro))
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
    <%= for {x,y} <- @points do %>
      <rect width="20" height="20" x={(x - 1) * 20} y={(y - 1) * 20} fill="white" />
    <% end %>
    """
  end

  defp new_tetromino(socket) do
    tetro = Tetromino.new_random()
    assign(socket, tetro: tetro)
  end

  defp show_points(socket) do
    assign(socket, points: Tetromino.points(socket.assigns.tetro))
  end
end
