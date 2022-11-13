defmodule Fl.Repo.Migrations.CreateTotalExpenses do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE TABLE total_expenses (
        id          BIGSERIAL NOT NULL,
        year_month_classifier  TIMESTAMP NOT NULL
      ) PARTITION BY RANGE (year_month_classifier)
      """,
      "DROP TABLE total_expenses"
    )

    create unique_index(:total_expenses, [:id, :year_month_classifier])

    execute(
      "CREATE TABLE total_expenses_default PARTITION OF total_expenses DEFAULT",
      "DROP TABLE total_expenses_default"
    )

    start_date =
      Date.utc_today()
      |> Date.beginning_of_month()
      |> beginning_of_month()

    for months <- 0..24 do
      create_partition("total_expenses", calculate_next_month(start_date, months))
    end
  end

  defp create_partition(table, date) do
    start_date = date
    stop_date = Date.add(date, Date.days_in_month(date))

    month =
      start_date.month
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    execute(
      """
      CREATE TABLE #{table}_p#{start_date.year}_#{month}
      PARTITION OF #{table} FOR VALUES
      FROM ('#{start_date}')
      TO ('#{stop_date}')
      """,
      "DROP TABLE #{table}_p#{start_date.year}_#{month}"
    )
  end

  def beginning_of_month(date) do
    if date.day == 1 do
      date
    else
      Date.add(date, -(date.day - 1))
    end
  end

  def calculate_next_month(date, 0), do: date

  def calculate_next_month(date, months) do
    next = Date.add(date, Date.days_in_month(date))
    calculate_next_month(next, months - 1)
  end
end
