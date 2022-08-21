defmodule SimpleCounter do
  use Phoenix.Component

  def display(%{inc2: inc2} = assigns) do
    ~H"""
      <button id="b2"  phx-click="inc2" phx-value-inc2={inc2} >Func Comp: +<%= inc2 %></button>
    """
  end
end
