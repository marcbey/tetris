defmodule Tetris.HighScores do
  @moduledoc """
  Context for managing high scores (Ash powered).
  """

  alias Tetris.AshDomain
  alias Tetris.HighScores.ScoreResource

  @spec submit(String.t(), non_neg_integer()) :: {:ok, struct()} | {:error, term()}
  def submit(player_name, score) when is_binary(player_name) and is_integer(score) do
    name = sanitize_name(player_name)

    Ash.create(ScoreResource, %{player_name: name, score: score}, domain: AshDomain, action: :submit)
  end

  @spec top(pos_integer()) :: [struct()]
  def top(limit \\ 10) when is_integer(limit) and limit > 0 do
    ScoreResource
    |> Ash.Query.new()
    |> Ash.Query.sort(score: :desc, inserted_at: :asc)
    |> Ash.Query.limit(limit)
    |> Ash.read!(domain: AshDomain)
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
