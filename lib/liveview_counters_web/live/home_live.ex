defmodule LiveviewCountersWeb.HomeLive do
  use Phoenix.LiveView
  alias Phoenix.LiveView.JS
  require WaitForIt
  require Logger

  # @topic "counters"
  # @topic inspect(__MODULE__)

  @impl true
  def mount(_, _, socket) do
    if connected?(socket), do: IO.inspect(socket, label: "parent")
    # Phoenix.PubSub.subscribe(LiveviewCountersWeb.PubSub, @topic)
    # LiveviewCountersWeb.Endpoint.subscribe(@topic)

    {:ok,
     assign(socket,
       count: 0,
       prefetching: false,
       count6: 0,
       clicks: %{b1: 0, b2: 0, b3: 0, b4: 0, b5: 0, b6: 0, b7: 0},
       data: nil,
       display_data: nil
     )}
  end

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <button id="b1"  phx-click="inc1" phx-value-inc1={1}>Increment: +1</button>

    <SimpleCounter.display inc2={10} />

    <.live_component module={LiveButton} id="b3" inc3={100} int={0}/>

    <HookButton.display inc4={1000}/>

    <ReactButtons.display inc5={10_000} inc6={100_000}/>

    <HoverComp.display inc7={1_000_000}/>

    <h1>Counter: <%= @count %></h1>
    <h3><%= inspect(@clicks)%></h3>
    <h3><%= inspect(@display_data) %></h3>
    """
  end

  # <span id="b10" phx-hook="Hover"
  #     style="border: 0.1rem solid; padding: 1rem 3.15rem; cursor: pointer; border-radius: 0.4rem;display: inline-block;"
  #     phx-click={JS.push("inc7", value: %{inc7: 1_000_000})}
  # > Add +1_000_000! </span>

  @impl true
  def handle_event("prefetch", _, socket) do
    case socket.assigns.prefetching do
      true ->
        case WaitForIt.wait(:ets.lookup(:counters, :data) != []) do
          #  frequency: 1_000,
          #  timeout: 2_000
          # ) do
          {:ok, data} ->
            {:noreply, socket |> assign(:data, data)}

          {:timeout, _} ->
            {:noreply, socket}
        end

      false ->
        case :ets.lookup(:counters, :data) do
          [] ->
            Logger.info("prefetch")
            socket = update(socket, :prefetching, &(!&1))

            case LiveviewCounters.FetchData.async(1) do
              {:ok, data} ->
                socket = update(socket, :prefetching, &(!&1))
                {:noreply, socket |> assign(:data, data)}

              {:error, reason} ->
                socket = update(socket, :prefetching, &(!&1))
                Logger.debug(reason)
                {:noreply, socket}
            end

          [data] ->
            Logger.info("CACHED")
            {:noreply, socket |> assign(:data, data)}
        end
    end
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
  def handle_event("ssr", %{"inc6" => inc6}, socket) do
    IO.inspect(inc6)
    # inc6 = String.to_integer(inc6)
    socket =
      socket
      |> update(:count6, &(&1 + 1))
      |> update(:count, &(&1 + inc6))
      |> update(:clicks, &Map.put(&1, :b6, &1.b6 + 1))

    IO.inspect(socket.assigns)
    # new_count = socket.assigns.count + inc6
    # socket (socket, count: new_count)
    # {:noreply, push_event(socket, "incSSR", %{newCount: new_count})}
    {:reply, %{newCount: socket.assigns.count6}, socket}
  end

  @impl true
  def handle_event("inc7", %{"inc7" => inc7}, socket) do
    socket =
      socket
      |> update(:count, &(&1 + inc7))
      |> update(:clicks, &Map.put(&1, :b7, &1.b7 + 1))
      |> assign(display_data: socket.assigns.data)

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
