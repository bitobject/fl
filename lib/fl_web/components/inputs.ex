defmodule FlWeb.Components.Inputs do
  use Phoenix.Component
  use Phoenix.HTML
  import FlWeb.ErrorHelpers

  attr :field, :string, required: true
  attr :f, :map, required: true

  def text_input(assigns) do
    ~H"""
    <div class="block">
      <div class="flex">
        <%= label @f, @field, class: "block p-2 font-bold" %>
        <%= error_tag @f, @field, class: "block" %>
      </div>
      <%= text_input @f, @field, "phx-debounce": "500", class: "bg-white rounded-2xl w-full max-w-xs" %>
    </div>
    """
  end

  attr :field, :string, required: true
  attr :f, :map, required: true
  attr :options, :list, default: []
  attr :class, :string, default: ""

  def select_input(assigns) do
    ~H"""
    <div class="block">
      <div class="flex">
        <%= label @f, @field, class: "block p-2 font-bold" %>
        <%= error_tag @f, @field, class: "block" %>
      </div>
      <%= select @f, @field, @options, "phx-debounce": "500", class: "bg-white rounded-2xl w-full max-w-xs #{@class}" %>
    </div>
    """
  end

  attr :field, :string, required: true
  attr :f, :map, required: true

  def number_input(assigns) do
    ~H"""
    <div class="block">
      <div class="flex">
        <%= label @f, @field, class: "block p-2 font-bold" %>
        <%= error_tag @f, @field, class: "block" %>
      </div>
      <%= number_input @f, @field, step: "any", "phx-debounce": "500", class: "bg-white rounded-2xl w-full max-w-xs" %>
    </div>
    """
  end

  def number_input(assigns) do
    ~H"""
    <div class="block">
      <div class="flex">
        <%= label @f, @field, class: "block p-2 font-bold" %>
        <%= error_tag @f, @field, class: "block" %>
      </div>
      <%= number_input @f, @field, step: "any", "phx-debounce": "500", class: "bg-white rounded-2xl w-full max-w-xs" %>
    </div>
    """
  end

  attr :field, :string, required: true
  attr :f, :map, required: true

  def datetime_select_input(assigns) do
    ~H"""
    <div class="block">
      <div class="flex">
        <%= label @f, @field, class: "block p-2 font-bold" %>
        <%= error_tag @f, @field, class: "block" %>
      </div>
      <%= datetime_select_with_hidden_time @f, @field, "phx-debounce": "500", class: "bg-white rounded-2xl w-full max-w-xs" %>
    </div>
    """
  end

  defp datetime_select_with_hidden_time(form, field, opts \\ []) do
    builder = fn b ->
      assigns = %{b: b}

      ~H"""
      <%= @b.(:day, []) %> / <%= @b.(:month, []) %> / <%= @b.(:year, []) %>
      <div class="hidden">
        <%= @b.(:hour, []) %> : <%= @b.(:minute, []) %>
      </div>
      """
    end

    datetime_select(form, field, [builder: builder] ++ opts)
  end
end
