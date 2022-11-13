defmodule Fl.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :type, :string, null: false

      timestamps()
    end
  end
end
