defmodule FlWeb.TotalExpenseLive.Show do
  use FlWeb, :live_view

  alias Fl.TotalExpenses

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:total_expense, TotalExpenses.get_total_expense!(id))}
  end

  defp page_title(:show), do: "Show Total expense"
  defp page_title(:edit), do: "Edit Total expense"
end
