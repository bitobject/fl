defmodule Fl.Repo.Migrations.CreateTotalExpenses do
  use Ecto.Migration

  def change do
    create table(:total_expenses) do
      add :description, :string
      add :timestamp, :timestamptz
      add :type, :string
      add :value, :map
      add :card_id, references(:cards, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing), null: false
      add :group_id, references(:groups, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:total_expenses, [:card_id])
    create index(:total_expenses, [:group_id])
    create index(:total_expenses, [:category_id])
  end
end
