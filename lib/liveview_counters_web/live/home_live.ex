defmodule LiveviewCountersWeb.HomeLive do
  use Phoenix.LiveView
  # alias Phoenix.LiveView.JS
  require WaitForIt
  require Logger

  # @topic "counters"
  # @topic inspect(__MODULE__)

  @impl true
  def mount(_, _, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(LiveviewCounters.PubSub, "counter")
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

    <button phx-hook="Notify" id="b11" phx-click="notify">Notify?</button>

    <h1>Counter: <%= @count %></h1>
    <h3><%= Jason.encode!(@clicks) %></h3>
    <h3><%= if @display_data != nil, do: Jason.encode!(elem(@display_data,1)) %></h3>
    """
  end

  defp update_socket(socket, key, inc) do
    socket =
      socket
      |> update(:count, &(&1 + inc))
      |> update(:clicks, &Map.put(&1, key, &1[key] + 1))

    message = %{clicks: socket.assigns.clicks, count: socket.assigns.count}
    Phoenix.PubSub.broadcast(LiveviewCounters.PubSub, "counter", message)
    socket
  end

  @impl true
  def handle_event("notify", _, socket) do
    {:noreply, push_event(socket, "notif", %{})}
  end

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
                {:noreply, socket |> assign(:data, {:data, data})}

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
    socket = update_socket(socket, :b1, String.to_integer(inc1))

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc2", %{"inc2" => inc2}, socket) do
    socket = update_socket(socket, :b2, String.to_integer(inc2))

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc4", %{"inc4" => inc4}, socket) do
    socket = update_socket(socket, :b4, inc4)

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc5", %{"inc5" => inc5}, socket) do
    socket = update_socket(socket, :b5, inc5)

    {:noreply, socket}
  end

  # callback from client pushEvent
  @impl true
  def handle_event("ssr", %{"inc6" => inc6}, socket) do
    socket =
      update_socket(socket, :b6, inc6)
      |> update(:count6, &(&1 + 1))

    {:reply, %{newCount: socket.assigns.count6}, socket}
  end

  # alternative to above: client has callback handleEvent
  @impl true
  def handle_event("ssr2", %{"inc6" => inc6}, socket) do
    IO.puts("ssr2")

    socket =
      update_socket(socket, :b6, inc6)
      |> update(:count6, &(&1 + 1))

    {:noreply, push_event(socket, "server", %{newCount: socket.assigns.count6})}
  end

  @impl true
  # click to fetch data from fake button and send notification BTW
  def handle_event("inc7", %{"inc7" => inc7}, socket) do
    socket =
      update_socket(socket, :b7, inc7)
      |> assign(:display_data, socket.assigns.data)

    {:noreply, push_event(socket, "notif", %{msg: "data here!"})}
  end

  @impl true
  def handle_info(%{inc3: inc3}, socket) do
    socket = update_socket(socket, :b3, String.to_integer(inc3))
    {:noreply, socket}
  end

  def handle_info(%{clicks: clicks, count: count} = _message, socket) do
    IO.inspect(clicks, label: "info")
    {:noreply, socket}
  end
end
