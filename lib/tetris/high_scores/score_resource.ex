defmodule Tetris.HighScores.ScoreResource do
  use Ash.Resource, domain: Tetris.AshDomain, data_layer: AshPostgres.DataLayer

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
      generated? true
    end

    attribute :player_name, :string do
      allow_nil? false
      constraints min_length: 1, max_length: 15
    end

    attribute :score, :integer do
      allow_nil? false
      default 0
      constraints min: 0
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  # Additional validations can be added here if needed
end
