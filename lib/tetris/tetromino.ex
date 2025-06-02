defmodule Tetris.Tetromino do
  defstruct shape: :l, rotation: 0, location: {3, 1}

  alias Tetris.{Point, Points}

  def new(options \\ []) do
    __struct__(options)
  end

  def new_random() do
    new(shape: random_shape())
  end

  def right(tetro) do
    %{tetro | location: Point.right(tetro.location)}
  end

  def left(tetro) do
    %{tetro | location: Point.left(tetro.location)}
  end

  def down(tetro) do
    %{tetro | location: Point.down(tetro.location)}
  end

  def rotate(tetro) do
    %{tetro | rotation: rotate_degrees(tetro.rotation)}
  end

  def show(tetro) do
    tetro |> points |> Points.move(tetro.location)
  end

  def points(%{shape: :l} = _tetro) do
    [
      {2, 1},
      {2, 2},
      {2, 3}, {3, 3}
    ]
  end

  def points(%{shape: :j} = _tetro) do
    [
              {3, 1},
              {3, 2},
      {2, 3}, {3, 3}
    ]
  end

  def points(%{shape: :o} = _tetro) do
    [
      {2, 1}, {2, 2},
      {2, 3}, {3, 3},
    ]
  end

  def points(%{shape: :s} = _tetro) do
    [
              {2, 2}, {3, 2},
      {1, 3}, {2, 3},
    ]
  end

  def points(%{shape: :z} = _tetro) do
    [
      {1, 2}, {2, 2},
              {2, 3}, {3, 3},
    ]
  end

 def points(%{shape: :t} = _tetro) do
    [
      {1, 2}, {2, 2}, {3, 2},
              {2, 3},
    ]
  end

  def points(%{shape: :i} = _tetro) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {2, 4}
    ]
  end

  defp rotate_degrees(270) do
    0
  end

  defp rotate_degrees(n) do
    n + 90
  end

  defp random_shape do
    # Enum.random([:l, :j, :o, :s, :z, :t, :i])
    ~w(l j o s z t i)a |> Enum.random()
  end
end
