defmodule Fl.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :img, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :img])
    |> validate_required([:name, :img])
  end
end
