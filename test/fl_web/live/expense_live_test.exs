defmodule FlWeb.ExpenseLiveTest do
  use FlWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fl.ExpensesFixtures

  @create_attrs %{
    img: "some img",
    description: "some description",
    timestamp: %{day: 22, hour: 22, minute: 41, month: 10, year: 2022},
    type: "some type",
    value: 120.5
  }
  @update_attrs %{
    img: "some updated img",
    description: "some updated description",
    timestamp: %{day: 23, hour: 22, minute: 41, month: 10, year: 2022},
    type: "some updated type",
    value: 456.7
  }
  @invalid_attrs %{
    img: nil,
    description: nil,
    timestamp: %{day: 30, hour: 22, minute: 41, month: 2, year: 2022},
    type: nil,
    value: nil
  }

  defp create_expense(_) do
    expense = expense_fixture()
    %{expense: expense}
  end

  describe "Index" do
    setup [:create_expense]

    test "lists all expenses", %{conn: conn, expense: expense} do
      {:ok, _index_live, html} = live(conn, Routes.expense_index_path(conn, :index))

      assert html =~ "Listing Expenses"
      assert html =~ expense.img
    end

    test "saves new expense", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.expense_index_path(conn, :index))

      assert index_live |> element("a", "New Expense") |> render_click() =~
               "New Expense"

      assert_patch(index_live, Routes.expense_index_path(conn, :new))

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#expense-form", expense: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.expense_index_path(conn, :index))

      assert html =~ "Expense created successfully"
      assert html =~ "some img"
    end

    test "updates expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, Routes.expense_index_path(conn, :index))

      assert index_live |> element("#expense-#{expense.id} a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(index_live, Routes.expense_index_path(conn, :edit, expense))

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#expense-form", expense: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.expense_index_path(conn, :index))

      assert html =~ "Expense updated successfully"
      assert html =~ "some updated img"
    end

    test "deletes expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, Routes.expense_index_path(conn, :index))

      assert index_live |> element("#expense-#{expense.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#expense-#{expense.id}")
    end
  end

  describe "Show" do
    setup [:create_expense]

    test "displays expense", %{conn: conn, expense: expense} do
      {:ok, _show_live, html} = live(conn, Routes.expense_show_path(conn, :show, expense))

      assert html =~ "Show Expense"
      assert html =~ expense.img
    end

    test "updates expense within modal", %{conn: conn, expense: expense} do
      {:ok, show_live, _html} = live(conn, Routes.expense_show_path(conn, :show, expense))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(show_live, Routes.expense_show_path(conn, :edit, expense))

      assert show_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#expense-form", expense: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.expense_show_path(conn, :show, expense))

      assert html =~ "Expense updated successfully"
      assert html =~ "some updated img"
    end
  end
end
