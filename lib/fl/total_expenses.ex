defmodule Fl.TotalExpenses do
  @moduledoc """
  The TotalExpenses context.
  """

  import Ecto.Query, warn: false
  import Fl.ContextHelper

  alias Fl.Repo

  alias Fl.TotalExpenses.TotalExpense

  @periods ~w(day week month year)a
  @main_currency "AMD"

  defdelegate apply_changes(changesetr), to: Ecto.Changeset

  @doc """
  Returns the list of total_expenses.

  ## Examples

      iex> list_total_expenses()
      [%TotalExpense{}, ...]

  """
  def list_total_expenses do
    Repo.all(TotalExpense)
  end

  @doc """
  Gets a single total_expense.

  Raises `Ecto.NoResultsError` if the TotalExpense does not exist.

  ## Examples

      iex> get_total_expense!(123)
      %TotalExpense{}

      iex> get_total_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_total_expense!(id), do: Repo.get!(TotalExpense, id)

  @doc """
  Creates a total_expense.

  ## Examples

      iex> create_total_expense(%{field: value})
      {:ok, %TotalExpense{}}

      iex> create_total_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_total_expense(attrs \\ %{}) do
    %TotalExpense{}
    |> TotalExpense.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a total_expense.

  ## Examples

      iex> update_total_expense(total_expense, %{field: new_value})
      {:ok, %TotalExpense{}}

      iex> update_total_expense(total_expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_total_expense(%TotalExpense{} = total_expense, attrs) do
    total_expense
    |> TotalExpense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a total_expense.

  ## Examples

      iex> delete_total_expense(total_expense)
      {:ok, %TotalExpense{}}

      iex> delete_total_expense(total_expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_total_expense(%TotalExpense{} = total_expense) do
    Repo.delete(total_expense)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking total_expense changes.

  ## Examples

      iex> change_total_expense(total_expense)
      %Ecto.Changeset{data: %TotalExpense{}}

  """
  def change_total_expense(%TotalExpense{} = total_expense, attrs \\ %{}) do
    total_expense
    |> ExConstructor.populate_struct(attrs)
    |> TotalExpense.changeset(attrs)
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

  def sum_expenses_by_day_by_week_by_month(params, timezone \\ "Etc/UTC") do
    {day_start_time_unix, day_end_time_unix} =
      get_timestamps_by_period(:day, timezone, type: :unix)

    {week_start_time_unix, week_end_time_unix} =
      get_timestamps_by_period(:week, timezone, type: :unix)

    {month_start_time, month_end_time} = get_timestamps_by_period(:month, timezone)
    month_start_time_unix = Timex.to_unix(month_start_time)
    month_end_time_unix = Timex.to_unix(month_end_time)

    {day, week, month} =
      TotalExpense
      |> where(^params)
      |> where(
        [e],
        ^month_start_time <= e.year_month_classifier and
          e.year_month_classifier <= ^month_end_time
      )
      |> group_by([e], [
        fragment("DATE_TRUNC('day', ?)", e.timestamp),
        fragment("(?->>?)", e.value, "currency")
      ])
      |> select([e], {
        fragment("(?->>?)", e.value, "currency"),
        fragment("SUM((?->>?)::integer)", e.value, "amount"),
        fragment("DATE_TRUNC('day', ?)", e.timestamp)
      })
      |> Repo.all()
      |> Enum.reduce(
        {%{}, %{}, %{}},
        fn
          {currency, amount, timestamp}, {day, week, month} ->
            cond do
              Timex.to_unix(timestamp) in day_start_time_unix..day_end_time_unix ->
                day_expense_value = Map.get(day, currency, 0)
                week_expense_value = Map.get(week, currency, 0)
                month_expense_value = Map.get(month, currency, 0)

                {
                  Map.put(day, currency, day_expense_value + amount),
                  Map.put(week, currency, week_expense_value + amount),
                  Map.put(month, currency, month_expense_value + amount)
                }

              Timex.to_unix(timestamp) in week_start_time_unix..week_end_time_unix ->
                week_expense_value = Map.get(week, currency, 0)
                month_expense_value = Map.get(month, currency, 0)

                {
                  day,
                  Map.put(week, currency, week_expense_value + amount),
                  Map.put(month, currency, month_expense_value + amount)
                }

              Timex.to_unix(timestamp) in month_start_time_unix..month_end_time_unix ->
                month_expense_value = Map.get(month, currency, 0)

                {
                  day,
                  week,
                  Map.put(month, currency, month_expense_value + amount)
                }

              true ->
                {day, week, month}
            end
        end
      )

    {Map.to_list(day) |> Enum.map(&calculate_currencies/1),
     Map.to_list(week) |> Enum.map(&calculate_currencies/1),
     Map.to_list(month) |> Enum.map(&calculate_currencies/1)}
  end

  @doc """
  Returns the list of sorted by params total_expenses for a period.
  #TODO write all periods
  ## Examples

      iex> list_total_expenses_by()
      [%TotalExpense{}, ...]

  """
  def list_total_expenses_by(params) do
    case Filtrex.parse_params(Fl.TotalExpenses.FilterConfig.total_expense_config(), params) do
      {:ok, filter} ->
        TotalExpense
        |> Filtrex.query(filter)
        |> Repo.all()

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Returns the sum of sorted by params total_expenses for a period.
  #TODO write all periods
  ## Examples

      iex> sum_total_expenses_by_period()
      [%TotalExpense{}, ...]

  """
  def sum_total_expenses_by_period(period, params, timezone \\ "Etc/UTC")

  def sum_total_expenses_by_period(period, params, timezone) when period in @periods do
    # TODO refactor
    # - slice function on abstract levels
    # - make recurse
    {start_time, end_time} = get_timestamps_by_period(period, timezone)

    {total_expense_currencies, total_expense_main_currency} =
      TotalExpense
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

    [total_expense_main_currency | total_expense_currencies]
  end

  def sum_total_expenses_by_period(_period, _params, _) do
    []
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
