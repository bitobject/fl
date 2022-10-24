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
        name: "some name",
        timestamp: ~N[2022-10-22 22:38:00],
        type: "some type"
      })
      |> Fl.Expenses.create_expense()

    expense
  end

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        img: "some img",
        name: "some name",
        timestamp: ~N[2022-10-22 22:39:00],
        type: "some type",
        value: 120.5
      })
      |> Fl.Expenses.create_expense()

    expense
  end

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        img: "some img",
        name: "some name",
        timestamp: ~N[2022-10-22 22:41:00],
        type: "some type",
        value: 120.5
      })
      |> Fl.Expenses.create_expense()

    expense
  end
end
