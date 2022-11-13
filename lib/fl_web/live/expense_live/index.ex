defmodule FlWeb.ExpenseLive.Index do
  use FlWeb, :live_view
  on_mount FlWeb.LiveAuth

  alias Fl.Expenses
  alias Fl.TotalExpenses
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    timezone = socket.assigns.current_user.timezone

    {:ok, assign(socket, expenses: list_expenses(), timezone: timezone)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Expense")
    |> assign(:expense, Expenses.get_expense!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Expenses")
    |> assign(:expense, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    expense = Expenses.get_expense!(id)
    {:ok, _} = Expenses.delete_expense(expense)

    {:noreply, assign(socket, :expenses, list_expenses())}
  end

  defp list_expenses do
    Expenses.list_expenses()
  end

  defp list_expenses_by_period(period, params, timezone) do
    Expenses.list_expenses_by_period(period, params, timezone)
  end

  defp list_total_expenses_by_period(period, params, timezone) do
    TotalExpenses.list_total_expenses_by_period(period, params, timezone)
  end

  defp shift_to_local_time(timestamp, timezone),
    do: Timex.shift(timestamp, seconds: Timex.now(timezone).utc_offset)

  def toggle_row(id, js \\ %JS{}) do
    js
    |> JS.toggle(to: "##{id}", in: "fade-in-scale", out: "fade-out-scale", display: "table-row")
    |> JS.set_attribute({"COLSPAN", "5"}, to: "##{id}")
  end
end
