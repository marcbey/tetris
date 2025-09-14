defmodule Tetris.HighScores.ScoreResource do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "scores"
    repo Tetris.Repo
  end

  actions do
    defaults [:read]

    create :submit do
      accept [:player_name, :score]
    end
  end

  attributes do
    attribute :id, :integer do
      primary_key? true
      allow_nil? false
      writable? false
    end

    attribute :player_name, :string do
      allow_nil? false
    end

    attribute :score, :integer do
      allow_nil? false
      default 0
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  validations do
    validate present(:player_name)
    validate length(:player_name, max: 15)
    validate number(:score, greater_than_or_equal_to: 0)
  end
end

