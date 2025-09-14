defmodule Tetris.HighScores do
  @moduledoc """
  Context for managing high scores.
  """

  import Ecto.Query, warn: false
  alias Tetris.Repo
  alias Tetris.HighScores.Score

  @spec submit(String.t(), non_neg_integer()) :: {:ok, Score.t()} | {:error, Ecto.Changeset.t()}
  def submit(player_name, score) when is_binary(player_name) and is_integer(score) do
    %Score{}
    |> Score.changeset(%{player_name: player_name, score: score})
    |> Repo.insert()
  end

  @spec top(pos_integer()) :: [Score.t()]
  def top(limit \\ 10) when is_integer(limit) and limit > 0 do
    from(s in Score, order_by: [desc: s.score, asc: s.inserted_at], limit: ^limit)
    |> Repo.all()
  end
end

