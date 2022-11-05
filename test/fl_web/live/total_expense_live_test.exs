defmodule FlWeb.TotalExpenseLiveTest do
  use FlWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fl.TotalExpensesFixtures

  @create_attrs %{
    description: "some description",
    timestamp: %{day: 2, hour: 22, minute: 58, month: 11, year: 2022},
    type: :card,
    value: %{}
  }
  @update_attrs %{
    description: "some updated description",
    timestamp: %{day: 3, hour: 22, minute: 58, month: 11, year: 2022},
    type: :cash,
    value: %{}
  }
  @invalid_attrs %{
    description: nil,
    timestamp: %{day: 30, hour: 22, minute: 58, month: 2, year: 2022},
    type: nil,
    value: nil
  }

  defp create_total_expense(_) do
    total_expense = total_expense_fixture()
    %{total_expense: total_expense}
  end

  describe "Index" do
    setup [:create_total_expense]

    test "lists all total_expenses", %{conn: conn, total_expense: total_expense} do
      {:ok, _index_live, html} = live(conn, Routes.total_expense_index_path(conn, :index))

      assert html =~ "Listing Total expenses"
      assert html =~ total_expense.description
    end

    test "saves new total_expense", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.total_expense_index_path(conn, :index))

      assert index_live |> element("a", "New Total expense") |> render_click() =~
               "New Total expense"

      assert_patch(index_live, Routes.total_expense_index_path(conn, :new))

      assert index_live
             |> form("#total_expense-form", total_expense: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#total_expense-form", total_expense: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.total_expense_index_path(conn, :index))

      assert html =~ "Total expense created successfully"
      assert html =~ "some description"
    end

    test "updates total_expense in listing", %{conn: conn, total_expense: total_expense} do
      {:ok, index_live, _html} = live(conn, Routes.total_expense_index_path(conn, :index))

      assert index_live
             |> element("#total_expense-#{total_expense.id} a", "Edit")
             |> render_click() =~
               "Edit Total expense"

      assert_patch(index_live, Routes.total_expense_index_path(conn, :edit, total_expense))

      assert index_live
             |> form("#total_expense-form", total_expense: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#total_expense-form", total_expense: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.total_expense_index_path(conn, :index))

      assert html =~ "Total expense updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes total_expense in listing", %{conn: conn, total_expense: total_expense} do
      {:ok, index_live, _html} = live(conn, Routes.total_expense_index_path(conn, :index))

      assert index_live
             |> element("#total_expense-#{total_expense.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#total_expense-#{total_expense.id}")
    end
  end

  describe "Show" do
    setup [:create_total_expense]

    test "displays total_expense", %{conn: conn, total_expense: total_expense} do
      {:ok, _show_live, html} =
        live(conn, Routes.total_expense_show_path(conn, :show, total_expense))

      assert html =~ "Show Total expense"
      assert html =~ total_expense.description
    end

    test "updates total_expense within modal", %{conn: conn, total_expense: total_expense} do
      {:ok, show_live, _html} =
        live(conn, Routes.total_expense_show_path(conn, :show, total_expense))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Total expense"

      assert_patch(show_live, Routes.total_expense_show_path(conn, :edit, total_expense))

      assert show_live
             |> form("#total_expense-form", total_expense: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#total_expense-form", total_expense: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.total_expense_show_path(conn, :show, total_expense))

      assert html =~ "Total expense updated successfully"
      assert html =~ "some updated description"
    end
  end
end
