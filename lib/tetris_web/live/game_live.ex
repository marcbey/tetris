defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino

  @impl true
  def mount(_params, _session, socket) do
    :timer.send_interval(500, :tick)
    {:ok, socket |> new_tetromino |> show_points}
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, socket |> down |> rotate |> show_points}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <% {x, y} = @tetro.location %>
      <section class="phx-hero">
        <h>Welcome to Tetris!</h>
        <%= render_board(assigns) %>
        <pre>
          <%= "{" %> <%= x %>, <%= y %> <%= "}" %>
          <%= inspect(@tetro) %>
        </pre>
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
    <%= for {x, y, shape} <- @points do %>
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

  defp new_tetromino(socket) do
    tetro = Tetromino.new_random()
    assign(socket, tetro: tetro)
  end

  defp show_points(socket) do
    assign(socket, points: Tetromino.show(socket.assigns.tetro))
  end
end
