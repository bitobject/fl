defmodule Fl.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :img, :string, default: "img"
    field :name, :string
    field :timestamp, :naive_datetime, autogenerate: {__MODULE__, :utc_now, []}
    field :type, Ecto.Enum, values: [:card, :cash]
    field :value, Money.Ecto.Map.Type
    # field :value, :map
    field :card_id, :id
    field :category_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:name, :img, :timestamp, :type, :value, :card_id, :category_id, :user_id])
    |> validate_required([:name, :img, :timestamp, :type, :value, :category_id, :user_id])

    # |> validate_money(:value)
  end

  defp validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: value} when value > 0 -> []
      _, _ -> [value: "must be greater than 0"]
    end)
  end

  defp utc_now, do: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

  use ExConstructor
end
