defmodule Fl.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :description, :string
      add :img, :string
      add :timestamp, :utc_datetime
      add :type, :string
      add :value, :map
      add :card_id, references(:cards, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:expenses, [:card_id])
    create index(:expenses, [:category_id])
    create index(:expenses, [:user_id])
  end
end
