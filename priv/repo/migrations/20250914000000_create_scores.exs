defmodule Tetris.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :player_name, :string, null: false
      add :score, :integer, null: false, default: 0

      timestamps()
    end

    create index(:scores, [:score])
  end
end

