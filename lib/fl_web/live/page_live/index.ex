defmodule FlWeb.PageLive.Index do
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
      if group do
        Enum.map(group.users, fn u ->
          {u,
           {
             list_expenses_by_period(:day, [user_id: u.id], timezone),
             list_expenses_by_period(:week, [user_id: u.id], timezone),
             list_expenses_by_period(:month, [user_id: u.id], timezone)
           }}
        end)
      else
        []
      end

    total_expense =
      if group do
        {
          list_total_expenses_by_period(:day, [group_id: user.group_id], timezone),
          list_total_expenses_by_period(:week, [group_id: user.group_id], timezone),
          list_total_expenses_by_period(:month, [group_id: user.group_id], timezone)
        }
      else
        {[], [], []}
      end

    {:ok,
     assign(socket,
       expenses: list_expenses(),
       day_expenses: list_expenses_by_period(:day, params, timezone),
       week_expenses: list_expenses_by_period(:week, params, timezone),
       month_expenses: list_expenses_by_period(:month, params, timezone),
       timezone: timezone,
       group_expenses: group_expenses,
       group: group,
       total_expense: total_expense
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:expense, nil)}
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
end
