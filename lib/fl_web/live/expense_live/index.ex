defmodule FlWeb.ExpenseLive.Index do
  use FlWeb, :live_view
  on_mount FlWeb.LiveAuth

  alias Fl.Expenses
  alias Fl.Expenses.Expense
  alias Fl.Groups
  alias Fl.TotalExpenses
  alias Fl.TotalExpenses.TotalExpense

  @impl true
  def mount(_params, _session, socket) do
    params = [user_id: socket.assigns.current_user.id]
    timezone = socket.assigns.current_user.timezone
    user = socket.assigns.current_user

    group = Groups.get_group_without_current_user(user.group_id, user.id)

    group_expenses =
      Enum.map(group.users, fn u ->
        {u,
         {
           list_expenses_by_period(:day, [user_id: u.id], timezone),
           list_expenses_by_period(:week, [user_id: u.id], timezone),
           list_expenses_by_period(:month, [user_id: u.id], timezone)
         }}
      end)

    total_expenses = {
      list_total_expenses_by_period(:day, [group_id: user.group_id], timezone),
      list_total_expenses_by_period(:week, [group_id: user.group_id], timezone),
      list_total_expenses_by_period(:month, [group_id: user.group_id], timezone)
    }

    {:ok,
     assign(socket,
       expenses: list_expenses(),
       day_expenses: list_expenses_by_period(:day, params, timezone),
       week_expenses: list_expenses_by_period(:week, params, timezone),
       month_expenses: list_expenses_by_period(:month, params, timezone),
       timezone: timezone,
       group_expenses: group_expenses,
       total_expenses: total_expenses
     )}
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

  defp apply_action(socket, :new, _params) do
    expense = %Expense{
      timestamp: local_now(socket.assigns.current_user.timezone),
      user_id: socket.assigns.current_user.id
    }

    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, expense)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Expenses")
    |> assign(:expense, nil)
  end

  defp apply_action(socket, :total_new, _params) do
    total_expense =
      %TotalExpense{
        timestamp: local_now(socket.assigns.current_user.timezone),
        group_id: socket.assigns.current_user.group_id
      }
      |> IO.inspect()

    socket
    |> assign(:page_title, "New TotalExpense")
    |> assign(:total_expense, total_expense)
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

  defp local_now(timezone), do: Timex.now(timezone)

  defp shift_to_local_time(timestamp, timezone),
    do: Timex.shift(timestamp, seconds: Timex.now(timezone).utc_offset)
end
