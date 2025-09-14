defmodule Tetris.HighScores do
  @moduledoc """
  Context for managing high scores.
  """

  import Ecto.Query, warn: false
  alias Tetris.Repo
  alias Tetris.HighScores.Score

  @spec submit(String.t(), non_neg_integer()) :: {:ok, Score.t()} | {:error, Ecto.Changeset.t()}
  def submit(player_name, score) when is_binary(player_name) and is_integer(score) do
    name = sanitize_name(player_name)

    %Score{}
    |> Score.changeset(%{player_name: name, score: score})
    |> Repo.insert()
  end

  @spec top(pos_integer()) :: [Score.t()]
  def top(limit \\ 10) when is_integer(limit) and limit > 0 do
    from(s in Score, order_by: [desc: s.score, asc: s.inserted_at], limit: ^limit)
    |> Repo.all()
  end

  @doc """
  Normalizes a player name:
  - trims, collapses whitespace to single spaces
  - removes disallowed characters (keeps letters, digits, space, dot, underscore, hyphen)
  - caps length to 15
  - falls back to "Anonymous" if empty
  """
  @spec sanitize_name(String.t()) :: String.t()
  def sanitize_name(name) when is_binary(name) do
    name
    |> String.trim()
    |> String.replace(~r/\s+/u, " ")
    |> String.replace(~r/[^A-Za-z0-9 _\.\-]/u, "")
    |> String.slice(0, 15)
    |> case do
      "" -> "Anonymous"
      other -> other
    end
  end
end
