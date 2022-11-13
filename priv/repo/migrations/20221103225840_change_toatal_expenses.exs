defmodule Fl.Repo.Migrations.ChangeTotalExpenses do
  use Ecto.Migration

  def change do
    alter table(:total_expenses) do
      add :description, :string, null: false
      add :timestamp, :timestamptz, null: false
      add :type, :string, null: false
      add :value, :map
      add :card_id, references(:cards, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing), null: false
      add :group_id, references(:groups, on_delete: :nothing), null: false
      timestamps()
    end

    create index(:total_expenses, [:year_month_classifier])
    create index(:total_expenses, [:timestamp])
    create index(:total_expenses, [:card_id])
    create index(:total_expenses, [:category_id])
    create index(:total_expenses, [:group_id])
  end
end
