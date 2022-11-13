defmodule Fl.ExpensesTest do
  use Fl.DataCase

  alias Fl.Expenses

  # describe "expenses" do
  #   alias Fl.Expenses.Expense

  #   import Fl.ExpensesFixtures

  #   @invalid_attrs %{img: nil, description: nil, timestamp: nil, type: nil}

  #   test "list_expenses/0 returns all expenses" do
  #     expense = expense_fixture()
  #     assert Expenses.list_expenses() == [expense]
  #   end

  #   test "get_expense!/1 returns the expense with given id" do
  #     expense = expense_fixture()
  #     assert Expenses.get_expense!(expense.id) == expense
  #   end

  #   test "create_expense/1 with valid data creates a expense" do
  #     valid_attrs = %{
  #       img: "some img",
  #       description: "some description",
  #       timestamp: ~N[2022-10-22 22:38:00],
  #       type: "some type"
  #     }

  #     assert {:ok, %Expense{} = expense} = Expenses.create_expense(valid_attrs)
  #     assert expense.img == "some img"
  #     assert expense.description == "some description"
  #     assert expense.timestamp == ~N[2022-10-22 22:38:00]
  #     assert expense.type == "some type"
  #   end

  #   test "create_expense/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Expenses.create_expense(@invalid_attrs)
  #   end

  #   test "update_expense/2 with valid data updates the expense" do
  #     expense = expense_fixture()

  #     update_attrs = %{
  #       img: "some updated img",
  #       description: "some updated description",
  #       timestamp: ~N[2022-10-23 22:38:00],
  #       type: "some updated type"
  #     }

  #     assert {:ok, %Expense{} = expense} = Expenses.update_expense(expense, update_attrs)
  #     assert expense.img == "some updated img"
  #     assert expense.description == "some updated description"
  #     assert expense.timestamp == ~N[2022-10-23 22:38:00]
  #     assert expense.type == "some updated type"
  #   end

  #   test "update_expense/2 with invalid data returns error changeset" do
  #     expense = expense_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Expenses.update_expense(expense, @invalid_attrs)
  #     assert expense == Expenses.get_expense!(expense.id)
  #   end

  #   test "delete_expense/1 deletes the expense" do
  #     expense = expense_fixture()
  #     assert {:ok, %Expense{}} = Expenses.delete_expense(expense)
  #     assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense!(expense.id) end
  #   end

  #   test "change_expense/1 returns a expense changeset" do
  #     expense = expense_fixture()
  #     assert %Ecto.Changeset{} = Expenses.change_expense(expense)
  #   end
  # end

  describe "create expenses with different timezones" do
    alias Fl.Expenses.Expense

    import Fl.ExpensesFixtures
    import Fl.CategoriesFixtures
    import Fl.AccountsFixtures

    @invalid_attrs %{img: nil, description: nil, timestamp: nil, type: nil}

    test "create_expense/1 with valid data creates a expense" do
      nauru = DateTime.now!("Pacific/Nauru")
      warsaw = DateTime.now!("Europe/Warsaw")
      category = category_fixture()
      user = user_fixture()

      valid_attrs = %{
        img: "some img",
        description: "some description",
        timestamp: nil,
        type: "card",
        value: %Money{amount: 100, currency: "AMD"},
        user_id: user.id,
        category_id: category.id
      }

      assert {:ok, %Expense{timestamp: timestamp} = expense} =
               Expenses.create_expense(%{valid_attrs | timestamp: nauru}) |> IO.inspect()

      assert {:ok, %Expense{timestamp: timestamp} = expense} =
               Expenses.create_expense(%{valid_attrs | timestamp: warsaw}) |> IO.inspect()

      # assert expense.img == "some img"
      # assert expense.description == "some description"
      # assert expense.timestamp == ~N[2022-10-22 22:38:00]
      # assert expense.type == "some type"
    end
  end
end

# now = DateTime.utc_now() |> DateTime.truncate(:second)
# naive_now = NaiveDateTime.local_now()

# for i <- 1..10_000_000 do
#   datetime = DateTime.add(now, i, :minute)

#   params = %{
#     timestamp: datetime,
#     year_month_classifier: Timex.beginning_of_month(datetime),
#     description: "#{i}",
#     type: :card,
#     user_id: 2,
#     category_id: 1,
#     value: %Money{amount: 100, currency: :AMD},
#     inserted_at: naive_now,
#     updated_at: naive_now
#   }
# end
# |> Enum.chunk_every(7281)
# |> Enum.map(fn e ->
#   Fl.Repo.insert_all(Fl.Expenses.Expense, e)
# end)

# for i <- 1..10_000_000 do
#   datetime = DateTime.add(now, i, :minute)

#   params = %{
#     timestamp: datetime,
#     # date: DateTime.to_date(datetime),
#     description: "#{i}",
#     type: :card,
#     group_id: group.id,
#     category_id: 1,
#     value: %Money{amount: 100, currency: :AMD},
#     inserted_at: naive_now,
#     updated_at: naive_now
#   }
# end
# |> Enum.chunk_every(7281)
# |> Enum.map(fn e ->
#   Fl.Repo.insert_all(Fl.TotalExpenses.TotalExpense, e)
# end)
