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
    |> cast(attrs, [:description, :timestamp, :type, :value, :card_id, :group_id, :category_id])
    |> unique_constraint([:id, :year_month_classifier])
    |> validate_required([:description, :timestamp, :type, :value, :group_id, :category_id])
    |> change_field(:year_month_classifier)
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
