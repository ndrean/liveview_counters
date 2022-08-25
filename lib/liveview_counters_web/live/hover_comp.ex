defmodule HoverComp do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def display(assigns) do
    ~H"""
    <span id="b10" phx-hook="Hover"
        style="border: 0.1rem solid; padding: 1rem 3.15rem; border-radius: 0.4rem;display: inline-block;"
        phx-click={JS.push("inc7", value: %{inc7: @inc7})}
    > Add +<%= @inc7 %> </span>
    """
  end
end
