defmodule Fl.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :img, :string
    field :name, :string
    field :timestamp, :naive_datetime
    field :type, :string
    field :value, :float
    field :card_id, :id
    field :category_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:name, :img, :timestamp, :type, :value])
    |> validate_required([:name, :img, :timestamp, :type, :value])
  end
end
