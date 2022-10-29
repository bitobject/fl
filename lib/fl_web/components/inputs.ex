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

  def date_select_input(assigns) do
    ~H"""
    <div class="block">
      <div class="flex">
        <%= label @f, @field, class: "block p-2 font-bold" %>
        <%= error_tag @f, @field, class: "block" %>
      </div>
      <%= date_select @f, @field, "phx-debounce": "500", class: "bg-white rounded-2xl w-full max-w-xs" %>
    </div>
    """
  end
end
