defmodule Fl.TotalExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fl.TotalExpenses` context.
  """

  @doc """
  Generate a total_expense.
  """
  def total_expense_fixture(attrs \\ %{}) do
    {:ok, total_expense} =
      attrs
      |> Enum.into(%{
        description: "some description",
        timestamp: ~N[2022-11-02 22:58:00],
        type: :card,
        value: %{}
      })
      |> Fl.TotalExpenses.create_total_expense()

    total_expense
  end
end
