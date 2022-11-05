defmodule FlWeb.Components.Cards do
  use Phoenix.Component

  attr :title, :string, required: true

  def card(assigns) do
    ~H"""
      <div class="rounded-2xl border border-gray-900 border-4">
        <div class="text-xl text-gray-900 p-4 break-words">
          <p class="text-sm font-semibold text-gray-400"><%= @title %></p>
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

  def button_card(assigns) do
    ~H"""
    <div {@rest}>
      <div class="w-24 p-4 bg-gray-900 rounded-2xl text-center text-gray-200 mx-auto mb-4">
        <%= render_slot(@inner_block) %>
      </div>
      <h5 class="font-bold"><%= @title %></h5>
    </div>
    """
  end

  attr :title, :string, required: true

  def group_card(assigns) do
    ~H"""
    <div class="w-full max-w-md rounded-2xl border border-gray-900 border-4 p-4">
      <p class="text-sm font-semibold"><%= @u.email %></p>
      <ul class="grid grid-cols-3 text-sm text-gray-400">
        <li class="">today</li>
        <li class="">week</li>
        <li class="">month</li>
      </ul>
      <ul class="grid grid-cols-3">
        <li class="">
          <%= for expense <- elem(@group_expense, 0) do %>
            <div class="items-center text-gray-900 break-words">
              <p class="text-md font-bold"><%= expense.currency %> <%= expense.amount %></p>
            </div>
          <% end %>
        </li>
        <li class="">
          <%= for expense <- elem(@group_expense, 1) do %>
            <div class="items-center text-gray-900 break-words">
              <p class="text-md font-bold"><%= expense.currency %> <%= expense.amount %></p>
            </div>
          <% end %>
        </li>
        <li class="">
          <%= for expense <- elem(@group_expense, 2) do %>
            <div class="items-center text-gray-900 break-words">
              <p class="text-md font-bold"><%= expense.currency %> <%= expense.amount %></p>
            </div>
          <% end %>
        </li>
      </ul>
    </div>
    """
  end

  attr :rest, :global

  def total_card(assigns) do
    ~H"""
    <div class={@rest.class}>
      <p class="text-sm font-semibold"><%= @rest.title %></p>
      <ul class="grid grid-cols-3 text-sm text-gray-400">
        <li class="">today</li>
        <li class="">week</li>
        <li class="">month</li>
      </ul>
      <ul class="grid grid-cols-3">
        <li class="">
          <%= for expense <- elem(@rest.total_expense, 0) do %>
            <div class="items-center text-gray-900 break-words">
              <p class="text-md font-bold"><%= expense.currency %> <%= expense.amount %></p>
            </div>
          <% end %>
        </li>
        <li class="">
          <%= for expense <- elem(@rest.total_expense, 1) do %>
            <div class="items-center text-gray-900 break-words">
              <p class="text-md font-bold"><%= expense.currency %> <%= expense.amount %></p>
            </div>
          <% end %>
        </li>
        <li class="">
          <%= for expense <- elem(@rest.total_expense, 2) do %>
            <div class="items-center text-gray-900 break-words">
              <p class="text-md font-bold"><%= expense.currency %> <%= expense.amount %></p>
            </div>
          <% end %>
        </li>
      </ul>
    </div>
    """
  end
end
