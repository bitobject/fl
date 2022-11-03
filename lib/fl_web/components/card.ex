defmodule FlWeb.Components.Card do
  use Phoenix.Component

  attr :title, :string, required: true

  def card(assigns) do
    ~H"""
      <div class="w-64 bg-gray-900 text-gray-200 rounded-2xl">
        <div class="p-4 break-words">
          <p class="font-semibold"><%= @title %></p>
          <%= for expense <- @expenses do %>
            <h5 class="text-2xl font-bold">
              <%= expense.currency %>
              <%= expense.amount %>
            </h5>
          <% end %>
        </div>
      </div>
    """
  end

  slot(:inner_block)
  attr :rest, :global
  attr :title, :string, required: true

  def main_card(assigns) do
    ~H"""
      <div {@rest}>
        <div class="w-full max-w-xs h-40 p-4 bg-gray-900 rounded-2xl text-center text-gray-200 py-12">
          <h5 class="text-2xl font-bold"><%= @title %></h5>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    """
  end
end
