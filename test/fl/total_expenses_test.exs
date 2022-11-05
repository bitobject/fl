defmodule Fl.TotalExpensesTest do
  use Fl.DataCase

  alias Fl.TotalExpenses

  describe "total_expenses" do
    alias Fl.TotalExpenses.TotalExpense

    import Fl.TotalExpensesFixtures

    @invalid_attrs %{description: nil, timestamp: nil, type: nil, value: nil}

    test "list_total_expenses/0 returns all total_expenses" do
      total_expense = total_expense_fixture()
      assert TotalExpenses.list_total_expenses() == [total_expense]
    end

    test "get_total_expense!/1 returns the total_expense with given id" do
      total_expense = total_expense_fixture()
      assert TotalExpenses.get_total_expense!(total_expense.id) == total_expense
    end

    test "create_total_expense/1 with valid data creates a total_expense" do
      valid_attrs = %{
        description: "some description",
        timestamp: ~N[2022-11-02 22:58:00],
        type: :card,
        value: %{}
      }

      assert {:ok, %TotalExpense{} = total_expense} =
               TotalExpenses.create_total_expense(valid_attrs)

      assert total_expense.description == "some description"
      assert total_expense.timestamp == ~N[2022-11-02 22:58:00]
      assert total_expense.type == :card
      assert total_expense.value == %{}
    end

    test "create_total_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TotalExpenses.create_total_expense(@invalid_attrs)
    end

    test "update_total_expense/2 with valid data updates the total_expense" do
      total_expense = total_expense_fixture()

      update_attrs = %{
        description: "some updated description",
        timestamp: ~N[2022-11-03 22:58:00],
        type: :cash,
        value: %{}
      }

      assert {:ok, %TotalExpense{} = total_expense} =
               TotalExpenses.update_total_expense(total_expense, update_attrs)

      assert total_expense.description == "some updated description"
      assert total_expense.timestamp == ~N[2022-11-03 22:58:00]
      assert total_expense.type == :cash
      assert total_expense.value == %{}
    end

    test "update_total_expense/2 with invalid data returns error changeset" do
      total_expense = total_expense_fixture()

      assert {:error, %Ecto.Changeset{}} =
               TotalExpenses.update_total_expense(total_expense, @invalid_attrs)

      assert total_expense == TotalExpenses.get_total_expense!(total_expense.id)
    end

    test "delete_total_expense/1 deletes the total_expense" do
      total_expense = total_expense_fixture()
      assert {:ok, %TotalExpense{}} = TotalExpenses.delete_total_expense(total_expense)

      assert_raise Ecto.NoResultsError, fn ->
        TotalExpenses.get_total_expense!(total_expense.id)
      end
    end

    test "change_total_expense/1 returns a total_expense changeset" do
      total_expense = total_expense_fixture()
      assert %Ecto.Changeset{} = TotalExpenses.change_total_expense(total_expense)
    end
  end
end
