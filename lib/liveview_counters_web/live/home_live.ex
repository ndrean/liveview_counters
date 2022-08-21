defmodule LiveviewCountersWeb.HomeLive do
  use Phoenix.LiveView
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_, _, socket) do
    {:ok, assign(socket, count: 0, clicks: %{b1: 0, b2: 0, b3: 0, b4: 0, b5: 0, b6: 0})}
  end

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <button id="b1"  phx-click="inc1" phx-value-inc1={1}>Increment: +1</button>

    <SimpleCounter.display inc2={10} />

    <.live_component module={LiveButton} id="b3" inc3={100} int={0}/>

    <HookButton.display inc4={1000}/>

    <ReactButtons.display inc5={10_000}/>

    <span
    style="border: 0.1rem solid; padding: 1rem 3.15rem; cursor: pointer; border-radius: 0.4rem;display: inline-block;"
    phx-click={JS.push("inc6", value: %{inc6: 1_000_000})}>Add +1_000_000!</span>

    <h1>Counter: <%= @count %></h1>
    """
  end

  @impl true
  def handle_event("inc1", %{"inc1" => inc1}, socket) do
    socket =
      socket
      |> update(:count, &(&1 + String.to_integer(inc1)))
      |> update(:clicks, &Map.put(&1, :b1, &1.b1 + 1))

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc2", %{"inc2" => inc2}, socket) do
    inc2 = String.to_integer(inc2)

    socket =
      socket
      |> update(:count, &(&1 + inc2))
      |> update(:clicks, &Map.put(&1, :b2, &1.b2 + 1))

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc4", %{"inc4" => inc4}, socket) do
    socket =
      socket
      |> update(:count, &(&1 + inc4))
      |> update(:clicks, &Map.put(&1, :b4, &1.b4 + 1))

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc5", %{"inc5" => inc5}, socket) do
    socket =
      socket
      |> update(:count, &(&1 + inc5))
      |> update(:clicks, &Map.put(&1, :b5, &1.b5 + 1))

    {:noreply, socket}
  end

  @impl true
  def handle_event("ssr", _, socket) do
    new_count = socket.assigns.count + 100_000
    socket = assign(socket, count: new_count)
    # {:noreply, push_event(socket, "incSSR", %{newCount: new_count})}
    {:reply, %{newCount: trunc(new_count / 100_000)}, socket}
  end

  @impl true
  def handle_event("inc6", %{"inc6" => inc6}, socket) do
    socket =
      socket
      |> update(:count, &(&1 + inc6))
      |> update(:clicks, &Map.put(&1, :b5, &1.b6 + 1))

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{inc3: inc3}, socket) do
    inc3 = String.to_integer(inc3)

    socket =
      socket
      |> update(:count, &(&1 + inc3))
      |> update(:clicks, &Map.put(&1, :b3, &1.b3 + 1))

    {:noreply, socket}
  end
end
