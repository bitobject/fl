defmodule Fl.ExpensesTest do
  use Fl.DataCase

  alias Fl.Expenses

  describe "expenses" do
    alias Fl.Expenses.Expense

    import Fl.ExpensesFixtures

    @invalid_attrs %{img: nil, name: nil, timestamp: nil, type: nil}

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Expenses.list_expenses() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Expenses.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      valid_attrs = %{img: "some img", name: "some name", timestamp: ~N[2022-10-22 22:38:00], type: "some type"}

      assert {:ok, %Expense{} = expense} = Expenses.create_expense(valid_attrs)
      assert expense.img == "some img"
      assert expense.name == "some name"
      assert expense.timestamp == ~N[2022-10-22 22:38:00]
      assert expense.type == "some type"
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Expenses.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      update_attrs = %{img: "some updated img", name: "some updated name", timestamp: ~N[2022-10-23 22:38:00], type: "some updated type"}

      assert {:ok, %Expense{} = expense} = Expenses.update_expense(expense, update_attrs)
      assert expense.img == "some updated img"
      assert expense.name == "some updated name"
      assert expense.timestamp == ~N[2022-10-23 22:38:00]
      assert expense.type == "some updated type"
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Expenses.update_expense(expense, @invalid_attrs)
      assert expense == Expenses.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Expenses.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Expenses.change_expense(expense)
    end
  end

  describe "expenses" do
    alias Fl.Expenses.Expense

    import Fl.ExpensesFixtures

    @invalid_attrs %{img: nil, name: nil, timestamp: nil, type: nil, value: nil}

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Expenses.list_expenses() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Expenses.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      valid_attrs = %{img: "some img", name: "some name", timestamp: ~N[2022-10-22 22:39:00], type: "some type", value: 120.5}

      assert {:ok, %Expense{} = expense} = Expenses.create_expense(valid_attrs)
      assert expense.img == "some img"
      assert expense.name == "some name"
      assert expense.timestamp == ~N[2022-10-22 22:39:00]
      assert expense.type == "some type"
      assert expense.value == 120.5
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Expenses.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      update_attrs = %{img: "some updated img", name: "some updated name", timestamp: ~N[2022-10-23 22:39:00], type: "some updated type", value: 456.7}

      assert {:ok, %Expense{} = expense} = Expenses.update_expense(expense, update_attrs)
      assert expense.img == "some updated img"
      assert expense.name == "some updated name"
      assert expense.timestamp == ~N[2022-10-23 22:39:00]
      assert expense.type == "some updated type"
      assert expense.value == 456.7
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Expenses.update_expense(expense, @invalid_attrs)
      assert expense == Expenses.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Expenses.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Expenses.change_expense(expense)
    end
  end

  describe "expenses" do
    alias Fl.Expenses.Expense

    import Fl.ExpensesFixtures

    @invalid_attrs %{img: nil, name: nil, timestamp: nil, type: nil, value: nil}

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Expenses.list_expenses() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Expenses.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      valid_attrs = %{img: "some img", name: "some name", timestamp: ~N[2022-10-22 22:41:00], type: "some type", value: 120.5}

      assert {:ok, %Expense{} = expense} = Expenses.create_expense(valid_attrs)
      assert expense.img == "some img"
      assert expense.name == "some name"
      assert expense.timestamp == ~N[2022-10-22 22:41:00]
      assert expense.type == "some type"
      assert expense.value == 120.5
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Expenses.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      update_attrs = %{img: "some updated img", name: "some updated name", timestamp: ~N[2022-10-23 22:41:00], type: "some updated type", value: 456.7}

      assert {:ok, %Expense{} = expense} = Expenses.update_expense(expense, update_attrs)
      assert expense.img == "some updated img"
      assert expense.name == "some updated name"
      assert expense.timestamp == ~N[2022-10-23 22:41:00]
      assert expense.type == "some updated type"
      assert expense.value == 456.7
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Expenses.update_expense(expense, @invalid_attrs)
      assert expense == Expenses.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Expenses.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Expenses.change_expense(expense)
    end
  end
end
