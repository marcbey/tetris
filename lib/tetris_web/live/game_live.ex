defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino

  @impl true
  def mount(_params, _session, socket) do
    :timer.send_interval(500, :tick)
    {:ok, socket |> new_tetromino}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <% {x, y} = @tetro.location %>
      <section class="phx-hero">
        <pre>
          shape: <%= inspect @tetro.shape %>
          rotation: <%= inspect @tetro.rotation %>
          location: <%= "{" %> <%= x %>, <%= y %> <%= "}" %>
        </pre>
      </section>
    """
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, down(socket)}
  end

  def new_tetromino(socket) do
    tetro = Tetromino.new_random()
    assign(socket, tetro: tetro)
  end

  def down(%Phoenix.LiveView.Socket{assigns: %{tetro: tetro}} = socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end

end
