defmodule FlWeb.TotalExpenseLive.New do
  use FlWeb, :live_view
  on_mount FlWeb.LiveAuth

  alias Fl.TotalExpenses.TotalExpense

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    total_expense = %TotalExpense{timestamp: local_now(user.timezone), group_id: user.group_id}

    {:ok,
     assign(socket,
       timezone: user.timezone,
       total_expense: total_expense,
       page_title: "New TotalExpense"
     )}
  end

  defp local_now(timezone), do: Timex.now(timezone)
end
