defmodule Fl.TotalExpenses.TotalExpense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "total_expenses" do
    field :description, :string
    field :timestamp, :utc_datetime
    field :type, Ecto.Enum, values: [:card, :cash]
    field :value, Money.Ecto.Map.Type
    field :year_month_classifier, :utc_datetime, redact: true
    field :card_id, :id
    field :group_id, :id
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(total_expense, attrs) do
    total_expense
    |> cast(attrs, [:description, :timestamp, :type, :value, :year_month_classifier, :card_id, :group_id, :category_id])
    |> validate_required([:description, :timestamp, :type, :value, :year_month_classifier, :group_id, :category_id])
  end

  use ExConstructor
end
