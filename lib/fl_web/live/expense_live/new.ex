defmodule FlWeb.ExpenseLive.New do
  use FlWeb, :live_view
  on_mount FlWeb.LiveAuth

  alias Fl.Expenses.Expense

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    expense = %Expense{
      timestamp: local_now(user.timezone),
      user_id: user.id
    }

    {:ok,
     assign(socket,
       timezone: user.timezone,
       expense: expense,
       page_title: "New Expense"
     )}
  end

  defp local_now(timezone), do: Timex.now(timezone)
end
