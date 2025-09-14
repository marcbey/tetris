defmodule Tetris.HighScores.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :player_name, :string
    field :score, :integer, default: 0

    timestamps()
  end

  def changeset(score, attrs) do
    score
    |> cast(attrs, [:player_name, :score])
    |> validate_required([:player_name, :score])
    |> validate_number(:score, greater_than_or_equal_to: 0)
    |> validate_length(:player_name, min: 1, max: 50)
  end
end

