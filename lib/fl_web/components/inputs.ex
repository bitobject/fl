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

  attr :field, :float, required: true
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

  attr :field, :string, required: true
  attr :f, :map, required: true
  attr :required, :boolean, default: false

  def password_input(assigns) do
    ~H"""
    <div class="block">
      <div class="flex">
        <%= label @f, @field, class: "block p-2 font-bold" %>
        <%= error_tag @f, @field, class: "block" %>
      </div>
      <%= password_input @f, @field, required: @required, "phx-debounce": "500", class: "bg-white rounded-2xl w-full max-w-xs" %>
    </div>
    """
  end

  attr :field, :string, required: true
  attr :f, :map, required: true
  attr :required, :boolean, default: false
  attr :label, :string, default: nil
  attr :class, :string, default: ""
  attr :label_class, :string, default: ""

  def checkbox_input(assigns) do
    ~H"""
    <div class="block">
      <div class="flex">
        <%= if @label do
            label @f, @field, @label, class: "block p-2 font-bold #{@label_class}"
            else
            label @f, @field, class: "block p-2 font-bold #{@label_class}"
            end %>
        <%= error_tag @f, @field, class: "block" %>
      </div>
      <%= checkbox @f, @field, required: @required, "phx-debounce": "500", class: "bg-white rounded-xl w-8 max-w-xs h-8 #{@class}" %>
    </div>
    """
  end

  attr :label, :string, default: "save"

  def submit_button(assigns) do
    ~H"""
    <div class="block">
      <%= submit @label, class: "bg-white rounded-2xl w-full max-w-xs p-2 border mt-4 uppercase font-semibold" %>
    </div>
    """
  end
end
