defmodule FlWeb.ExpenseLive.Index do
  use FlWeb, :live_view
  on_mount FlWeb.LiveAuth

  alias Fl.Expenses
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    timezone = socket.assigns.current_user.timezone

    {:ok, assign(socket, expenses: [], timezone: timezone)}
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

  defp apply_action(
         %{assigns: %{current_user: current_user, timezone: timezone}} = socket,
         :index,
         _params
       ) do
    socket
    |> assign(:page_title, "Listing Expenses")
    |> assign(:expense, nil)
    |> assign(:expenses, list_expenses_by(:month, %{"user_id" => current_user.id}, timezone))
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

  defp list_expenses_by(period, %{"user_id" => user_id} = params, timezone) do
    {date_start, date_end} =
      Fl.ContextHelper.get_timestamps_by_period(:month, timezone, type: :string)

    params = %{
      "timestamp_on_or_after" => date_start,
      "timestamp_on_or_before" => date_end,
      "year_month_classifier_on_or_after" => date_start,
      "year_month_classifier_on_or_before" => date_end,
      "user_id" => user_id
    }

    Expenses.list_expenses_by(params)
  end

  defp shift_to_local_time(timestamp, timezone),
    do: Timex.shift(timestamp, seconds: Timex.now(timezone).utc_offset)

  def toggle_row(id, caller_id, js \\ %JS{}) do
    js
    |> JS.toggle(to: "##{id}", display: "table-row")
    |> JS.toggle(to: "##{caller_id}", display: "table-row")
    |> JS.set_attribute({"COLSPAN", "5"}, to: "##{id}")
  end
end
