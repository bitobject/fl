defmodule FlWeb.Components.Card do
  use Phoenix.Component

  attr :title, :string, required: true

  def card(assigns) do
    ~H"""
      <div class="w-64 bg-gray-900 text-gray-200 rounded-2xl">
        <div class="p-4 break-words">
          <p class="font-semibold"><%= @title %></p>
          <%= for expense <- @expenses do %>
            <h5 class="font-bold">
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
      <div class="w-24 p-4 bg-gray-900 rounded-2xl text-center text-gray-200 mx-auto mb-4">
        <%= render_slot(@inner_block) %>
      </div>
      <h5 class="font-bold"><%= @title %></h5>
    </div>
    """
  end
end
