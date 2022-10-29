defmodule FlWeb.ExpenseLive.FormComponent do
  use FlWeb, :live_component

  alias Fl.{Cards, Categories, Expenses}

  @types ~w(cash card)
  @first_oprtion [key: "---select---", value: "", disabled: true, selected: true]
  @default_currencies ~w(EUR RUB USD AMD)a

  @impl true
  def update(%{expense: expense} = assigns, socket) do
    changeset = Expenses.change_expense(expense)
    categories = Categories.list_categories_name_and_id()
    cards = Cards.list_cards_name_and_id()
    currencies = list_currencies()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       changeset: changeset,
       cards: cards,
       types: @types,
       currency: nil,
       currencies: currencies,
       first_oprtion: @first_oprtion,
       categories: categories
     )}
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    expense_params = format_params(expense_params) |> IO.inspect()

    changeset =
      socket.assigns.expense
      |> Expenses.change_expense(expense_params)
      |> Map.put(:action, :validate)
      |> IO.inspect()

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"expense" => expense_params}, socket) do
    save_expense(socket, socket.assigns.action, expense_params)
  end

  defp save_expense(socket, :edit, expense_params) do
    expense_params = format_params(expense_params)

    case Expenses.update_expense(socket.assigns.expense, expense_params) |> IO.inspect() do
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
    expense_params = format_params(expense_params)

    socket.assigns.expense
    |> Expenses.change_expense(expense_params)
    |> Expenses.to_map()
    |> IO.inspect()
    |> Fl.Expenses.create_expense()
    |> case do
      {:ok, _expense} ->
        {:noreply,
         socket
         |> put_flash(:info, "Expense created successfully")
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

  defp format_params(params) do
    params
    |> format_timestamp_params()
    |> value_to_money()
  end

  defp format_timestamp_params(params) do
    timestamp_params =
      params
      |> Map.get("timestamp", %{})
      |> Map.merge(%{"hour" => "00", "minute" => "00"})

    Map.put(params, "timestamp", timestamp_params)
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
