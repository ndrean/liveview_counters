defmodule ReactButtons do
  use Phoenix.Component

  def display(assigns) do
    ~H"""
    <div id="b5"  phx-hook="ReactHook"  phx-update="ignore" data-inc5={@inc5} data-inc6={@inc6}></div>
    """
  end
end
