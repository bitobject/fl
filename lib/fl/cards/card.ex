defmodule Fl.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :img, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:name, :img])
    |> validate_required([:name, :img])
  end
end
