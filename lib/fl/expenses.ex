defmodule Fl.Expenses do
  @moduledoc """
  The Expenses context.
  """

  import Ecto.Query, warn: false
  alias Fl.Repo

  alias Fl.Expenses.Expense
  @periods ~w(day week month)a
  @main_currency "AMD"

  defdelegate apply_changes(changesetr), to: Ecto.Changeset

  @doc """
  Returns the list of expenses.

  ## Examples

      iex> list_expenses()
      [%Expense{}, ...]

  """
  def list_expenses do
    Repo.all(Expense)
  end

  @doc """
  Gets a single expense.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id), do: Repo.get!(Expense, id)

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    expense
    |> ExConstructor.populate_struct(attrs)
    |> Expense.changeset(attrs)
  end

  @doc """
  Returns a map from an `%Ecto.Changeset{}` with all changes.

  ## Examples

      iex> to_map(%Ecto.Changeset{})
      %{}

  """
  def to_map(%Ecto.Changeset{} = changeset) do
    changeset
    |> apply_changes()
    |> Map.from_struct()
    |> Map.drop([:__meta__])
  end

  @doc """
  Returns the list of sorted by params expenses for a period.
  #TODO write all periods
  ## Examples

      iex> list_expenses_by_period()
      [%Expense{}, ...]

  """
  def list_expenses_by_period(period, params, timezone \\ "Etc/UTC")

  def list_expenses_by_period(period, params, timezone) when period in @periods do
    # TODO refactor
    # - slice function on abstract levels
    # - make recurse
    {start_time, end_time} = get_timestamps_by_period(period, timezone)

    {expense_currencies, expense_main_currency} =
      Expense
      |> where(^params)
      |> where([e], ^start_time <= e.timestamp and e.timestamp <= ^end_time)
      # |> select([e], fragment("SUM((?->>?)::integer)", e.value, "amount") )
      |> group_by([e], fragment("(?->>?)", e.value, "currency"))
      |> select([e], {
        fragment("(?->>?)", e.value, "currency"),
        sum(fragment("(?->>?)::integer", e.value, "amount"))
      })
      |> Repo.all()
      |> Enum.map(&calculate_currencies/1)
      |> Enum.reduce({[], %Money{currency: @main_currency, amount: 0}}, fn i,
                                                                           {list,
                                                                            %{amount: amount} =
                                                                              sum} ->
        if i.amount_in_main_currency do
          sum = Map.put(sum, :amount, amount + i.amount_in_main_currency)
          {list, sum}
        else
          {[%Money{currency: i.currency, amount: i.amount} | list], sum}
        end
      end)

    [expense_main_currency | expense_currencies]
  end

  def list_expenses_by_period(_period, _params, _) do
    []
  end

  def get_timestamps_by_period(:week, timezone) do
    time = Timex.now(timezone)
    start_ts = Timex.beginning_of_week(time)
    end_ts = Timex.end_of_week(time)

    {start_ts, end_ts}
  end

  def get_timestamps_by_period(:month, timezone) do
    time = Timex.now(timezone)
    start_ts = Timex.beginning_of_month(time)
    end_ts = Timex.end_of_month(time)

    {start_ts, end_ts}
  end

  def get_timestamps_by_period(:day, timezone) do
    time = Timex.now(timezone)
    start_ts = Timex.beginning_of_day(time)
    end_ts = Timex.end_of_day(time)

    {start_ts, end_ts}
  end

  # TODO make this by internet and in memory
  defp calculate_currencies({"RUB", v}) do
    %{currency: "RUB", amount: v, amount_in_main_currency: v * 6.3, main_currency: @main_currency}
  end

  defp calculate_currencies({"EUR", v}) do
    %{currency: "EUR", amount: v, amount_in_main_currency: v * 394, main_currency: @main_currency}
  end

  defp calculate_currencies({"AMD", v}) do
    %{currency: "AMD", amount: v, amount_in_main_currency: v, main_currency: @main_currency}
  end

  defp calculate_currencies({"USD", v}) do
    %{currency: "USD", amount: v, amount_in_main_currency: v * 395, main_currency: @main_currency}
  end

  defp calculate_currencies({k, v}) do
    %{currency: k, amount: v, amount_in_main_currency: nil, main_currency: @main_currency}
  end
end
