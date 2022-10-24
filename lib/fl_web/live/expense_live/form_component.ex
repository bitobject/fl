defmodule FlWeb.ExpenseLive.FormComponent do
  use FlWeb, :live_component

  alias Fl.Expenses

  @impl true
  def update(%{expense: expense} = assigns, socket) do
    changeset = Expenses.change_expense(expense)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    changeset =
      socket.assigns.expense
      |> Expenses.change_expense(expense_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"expense" => expense_params}, socket) do
    save_expense(socket, socket.assigns.action, expense_params)
  end

  defp save_expense(socket, :edit, expense_params) do
    case Expenses.update_expense(socket.assigns.expense, expense_params) do
      {:ok, _expense} ->
        {:noreply,
         socket
         |> put_flash(:info, "Expense updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_expense(socket, :new, expense_params) do
    case Expenses.create_expense(expense_params) do
      {:ok, _expense} ->
        {:noreply,
         socket
         |> put_flash(:info, "Expense created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
