defmodule LiveButton do
  use Phoenix.LiveComponent

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  @impl true
  def render(assigns) do
    ~H"""
    <button id="b3" phx-click="inc3" phx-target={@myself} phx-value-inc3={@inc3} type="button">Live Button +<%= @inc3%>, clicked: <%= @int%></button>
    """
  end

  @impl true
  def handle_event("inc3", %{"inc3" => inc3}, socket) do
    socket = update(socket, :int, &(&1 + 1))
    send(self(), %{inc3: inc3, int: socket.assigns.int})
    {:noreply, socket}
  end
end
