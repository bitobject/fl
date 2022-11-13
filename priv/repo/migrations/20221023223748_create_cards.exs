defmodule Fl.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :name, :string, null: false
      add :img, :string

      timestamps()
    end
  end
end
