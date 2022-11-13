defmodule Fl.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :img, :string

      timestamps()
    end
  end
end
