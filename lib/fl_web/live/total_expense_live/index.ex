defmodule FlWeb.TotalExpenseLive.Index do
  use FlWeb, :live_view
  on_mount FlWeb.LiveAuth

  alias Fl.TotalExpenses
  alias Fl.TotalExpenses.TotalExpense
  alias Fl.Groups

  @impl true
  def mount(_params, _session, socket) do
    params = [group_id: socket.assigns.current_user.group_id]
    timezone = socket.assigns.current_user.timezone
    user = socket.assigns.current_user

    group = Groups.get_group_without_current_user(user.group_id, user.id)

    group_total_expenses =
      Enum.map(group.users, fn u ->
        {u,
         {
           list_total_expenses_by_period(:day, [group_id: u.group_id], timezone),
           list_total_expenses_by_period(:week, [group_id: u.group_id], timezone),
           list_total_expenses_by_period(:month, [group_id: u.group_id], timezone)
         }}
      end)
      |> IO.inspect()

    {:ok,
     assign(socket,
       total_expenses: list_total_expenses(),
       day_total_expenses: list_total_expenses_by_period(:day, params, timezone),
       week_total_expenses: list_total_expenses_by_period(:week, params, timezone),
       month_total_expenses: list_total_expenses_by_period(:month, params, timezone),
       timezone: timezone,
       group_total_expenses: group_total_expenses
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit TotalExpense")
    |> assign(:total_expense, TotalExpenses.get_total_expense!(id))
  end

  defp apply_action(socket, :new, _params) do
    total_expense = %TotalExpense{
      timestamp: local_now(socket.assigns.current_user.timezone),
      group_id: socket.assigns.current_user.group_id
    }

    socket
    |> assign(:page_title, "New TotalExpense")
    |> assign(:total_expense, total_expense)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing TotalExpenses")
    |> assign(:total_expense, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    total_expense = TotalExpenses.get_total_expense!(id)
    {:ok, _} = TotalExpenses.delete_total_expense(total_expense)

    {:noreply, assign(socket, :total_expenses, list_total_expenses())}
  end

  defp list_total_expenses do
    TotalExpenses.list_total_expenses()
  end

  defp list_total_expenses_by_period(period, params, timezone) do
    TotalExpenses.list_total_expenses_by_period(period, params, timezone)
  end

  defp local_now(timezone), do: Timex.now(timezone)

  defp shift_to_local_time(timestamp, timezone),
    do: Timex.shift(timestamp, seconds: Timex.now(timezone).utc_offset)
end
