defmodule Fl.Repo.Migrations.ChangeExpenses do
  use Ecto.Migration

  def change do
    alter table(:expenses) do
      add :description, :string, null: false
      add :img, :string
      add :timestamp, :timestamptz, null: false
      add :type, :string, null: false
      add :value, :map
      add :card_id, references(:cards, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:expenses, [:year_month_classifier])
    create index(:expenses, [:timestamp])
    create index(:expenses, [:card_id])
    create index(:expenses, [:category_id])
    create index(:expenses, [:user_id])
  end
end
