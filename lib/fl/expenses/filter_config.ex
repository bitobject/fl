# in lib/my_app/filter_config.ex
defmodule Fl.Expenses.FilterConfig do
  import Filtrex.Type.Config

  def expense_config() do
    defconfig do
      text([:type])
      datetime([:year_month_classifier, :timestamp])
      number([:card_id, :category_id, :user_id])
    end
  end
end
