defmodule Fl.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fl.Expenses` context.
  """

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        img: "some img",
        description: "some description",
        timestamp: ~N[2022-10-22 22:38:00],
        type: "some type",
        value: %Money{amount: 100, currency: :AMD}
      })
      |> Fl.Expenses.create_expense()

    expense
  end
end
