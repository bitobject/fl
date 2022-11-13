defmodule FlWeb.PageLive.Index do
  use FlWeb, :live_view
  on_mount FlWeb.LiveAuth

  alias Fl.Expenses
  alias Fl.Groups
  alias Fl.TotalExpenses

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    params = [user_id: current_user.id]
    timezone = current_user.timezone
    group = Groups.get_group_without_current_user(current_user.group_id, current_user.id)
    expense = list_expenses_by_day_by_week_by_month(params, timezone)

    group_expense =
      if group do
        Enum.map(group.users, fn u ->
          {u, list_expenses_by_day_by_week_by_month([user_id: u.id], timezone)}
        end)
      else
        nil
      end

    total_expense =
      if group do
        list_total_expenses_by_period([group_id: current_user.group_id], timezone)
      else
        nil
      end

    socket =
      socket
      |> assign(
        timezone: timezone,
        group: group,
        expense: expense,
        group_expense: group_expense,
        total_expense: total_expense
      )
      |> push_event("points", %{points: extract_expense_for_chartjs(expense)})

    {:ok, socket}
  end

  defp list_expenses_by_day_by_week_by_month(params, timezone),
    do: Expenses.list_expenses_by_day_by_week_by_month(params, timezone)

  defp list_total_expenses_by_period(params, timezone),
    do: TotalExpenses.list_expenses_by_day_by_week_by_month(params, timezone)

  defp extract_expense_for_chartjs({[], [], []}), do: [0, 0, 0]

  defp extract_expense_for_chartjs({[], [week | _], [month | _]}),
    do: [0, week.amount, month.amount]

  defp extract_expense_for_chartjs({[day | _], [week | _], [month | _]}),
    do: [day.amount, week.amount, month.amount]
end
