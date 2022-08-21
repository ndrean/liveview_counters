defmodule ReactButtons do
  use Phoenix.Component

  def display(assigns) do
    ~H"""
    <div id="b5"  phx-hook="ReactHook"  phx-update="ignore" data-inc5={@inc5}></div>
    """
  end
end
