defmodule Fl.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :img, :string, default: "img"
    field :description, :string
    field :timestamp, :utc_datetime
    field :type, Ecto.Enum, values: [:card, :cash]
    field :value, Money.Ecto.Map.Type
    field :year_month_classifier, :utc_datetime, redact: true
    field :card_id, :id
    field :category_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [
      :description,
      :img,
      :timestamp,
      :type,
      :value,
      :card_id,
      :category_id,
      :user_id
    ])
    |> validate_required([
      :description,
      :img,
      :timestamp,
      :type,
      :value,
      :category_id,
      :user_id
    ])
    |> unique_constraint([:id, :year_month_classifier])
    |> change_field(:year_month_classifier)

    # |> validate_money(:value)
  end

  defp validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: value} when value > 0 -> []
      _, _ -> [value: "must be greater than 0"]
    end)
  end

  defp change_field(changeset, :year_month_classifier) do
    timestamp =
      changeset
      |> fetch_field(:timestamp)
      |> elem(1)
      |> Timex.beginning_of_month()
      |> Timex.to_datetime()

    put_change(changeset, :year_month_classifier, timestamp)
  end

  use ExConstructor
end
