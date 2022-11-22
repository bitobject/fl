# in lib/my_app/filter_config.ex
defmodule Fl.TotalExpenses.FilterConfig do
  import Filtrex.Type.Config

  def total_expense_config() do
    defconfig do
      text([:type])
      datetime([:year_month_classifier, :timestamp])
      number([:card_id, :category_id, :group_id])
    end
  end
end
