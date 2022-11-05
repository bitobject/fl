defmodule FlWeb.TotalExpenseLive.FormComponent do
  use FlWeb, :live_component

  alias Fl.{Cards, Categories, TotalExpenses}

  @first_oprtion [key: "---select---", value: "", disabled: true, selected: true]
  @default_currencies ~w(EUR RUB USD AMD)a

  @impl true
  def update(%{total_expense: total_expense} = assigns, socket) do
    changeset = TotalExpenses.change_total_expense(total_expense)
    categories = Categories.list_categories_name_and_id()
    cards = Cards.list_cards_name_and_id()
    currencies = list_currencies()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       changeset: changeset,
       cards: cards,
       currency: nil,
       currencies: currencies,
       first_oprtion: @first_oprtion,
       categories: categories
     )}
  end

  @impl true
  def handle_event("validate", %{"total_expense" => total_expense_params}, socket) do
    changeset =
      socket.assigns.total_expense
      |> TotalExpenses.change_total_expense(total_expense_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"total_expense" => total_expense_params}, socket) do
    save_total_expense(socket, socket.assigns.action, total_expense_params)
  end

  defp save_total_expense(socket, :edit, total_expense_params) do
    case TotalExpenses.update_total_expense(socket.assigns.total_expense, total_expense_params) do
      {:ok, _total_expense} ->
        {:noreply,
         socket
         |> put_flash(:info, "TotalExpense updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_total_expense(socket, :new, total_expense_params) do
    total_expense_params = value_to_money(total_expense_params)
    timezone = socket.assigns.timezone

    socket.assigns.total_expense
    |> TotalExpenses.change_total_expense(total_expense_params)
    |> TotalExpenses.to_map()
    |> format_timestamp_params(timezone)
    |> Fl.TotalExpenses.create_total_expense()
    |> case do
      {:ok, _total_expense} ->
        {:noreply,
         socket
         |> put_flash(:info, "TotalExpense created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp list_currencies() do
    Money.Currency.all()
    |> Map.take(@default_currencies)
    |> Enum.map(fn {k, v} -> {"#{v.symbol} #{k} #{v.name}", k} end)
  end

  defp format_timestamp_params(%{timestamp: timestamp} = params, timezone) do
    %{params | timestamp: timestamp |> Timex.to_datetime(timezone) |> Timex.to_naive_datetime()}
  end

  defp value_to_money(%{"value" => ""} = params), do: Map.delete(params, "value")

  defp value_to_money(params) do
    money_params = Map.take(params, ["value", "currency"])

    Map.put(params, "value", parse_value(money_params))
  end

  defp parse_value(%{"value" => value, "currency" => currency}) when is_binary(value) do
    value
    |> Integer.parse()
    |> elem(0)
    |> Money.new(currency)
  end

  defp parse_value(%{"value" => value, "currency" => currency}) when is_integer(value),
    do: Money.new(value, currency)
end
