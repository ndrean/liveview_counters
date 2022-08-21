defmodule HookButton do
  use Phoenix.Component

  def display(assigns) do
    ~H"""
      <button id="b4"  phx-hook="ButtonHook" data-inc4={@inc4}>
        Hook button +<%= @inc4 %>
      </button>
    """
  end
end
