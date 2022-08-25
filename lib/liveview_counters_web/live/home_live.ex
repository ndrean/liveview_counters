defmodule LiveviewCountersWeb.HomeLive do
  use Phoenix.LiveView
  require WaitForIt
  require Logger

  @topic "counters"
  # @topic inspect(__MODULE__)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: LiveviewCountersWeb.Endpoint.subscribe(@topic)
    # Phoenix.PubSub.subscribe(LiveviewCounters.PubSub, "counter")

    {:ok,
     assign(socket,
       count: 0,
       prefetching: false,
       count6: 0,
       clicks: %{b1: 0, b2: 0, b3: 0, b4: 0, b5: 0, b6: 0, b7: 0},
       data: nil,
       display_data: nil,
       int: 0
     )}
  end

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <button id="b1"  phx-click="inc1" phx-value-inc1={1} type="button">Increment: +1 </button>

    <SimpleCounter.display inc2={10} />

    <.live_component module={LiveButton} id="b3" inc3={100} int={@int}/>

    <HookButton.display inc4={1000}/>

    <ReactButtons.display inc5={10_000} inc6={100_000}/>

    <HoverComp.display inc7={1_000_000}/>

    <button phx-hook="Notify" id="b11" phx-click="notify">Notify?</button>

    <h1 >Counter: <span id="counter"><%= @count %></span></h1>
    <h3 id="clicks-map"><%= Jason.encode!(@clicks) %></h3>
    <h3 id="displayed-data"><%= if @display_data != nil, do: Jason.encode!(elem(@display_data,1)) %></h3>
    """
  end

  defp update_socket(socket, key, inc, event) do
    socket =
      socket
      |> update(:count, &(&1 + inc))
      |> update(:clicks, &Map.put(&1, key, &1[key] + 1))

    # message = %{clicks: socket.assigns.clicks, count: socket.assigns.count}
    # message = sockets.assigns
    # Phoenix.PubSub.broadcast(LiveviewCounters.PubSub, "counter", message)
    LiveviewCountersWeb.Endpoint.broadcast!(@topic, event, %{message: socket.assigns})
    socket
  end

  @impl true
  def handle_event("notify", _, socket) do
    {:noreply, push_event(socket, "notif", %{})}
  end

  @impl true
  def handle_event("prefetch", _, socket) do
    IO.inspect(socket.connect_info)

    case socket.assigns.prefetching do
      true ->
        case WaitForIt.wait(:ets.lookup(:counters, :data) != []) do
          #  frequency: 1_000, timeout: 2_000
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
    socket = update_socket(socket, :b1, String.to_integer(inc1), "inc1")

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc2", %{"inc2" => inc2}, socket) do
    socket = update_socket(socket, :b2, String.to_integer(inc2), "inc2")

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc4", %{"inc4" => inc4}, socket) do
    socket = update_socket(socket, :b4, inc4, "inc4")

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc5", %{"inc5" => inc5}, socket) do
    socket = update_socket(socket, :b5, inc5, "inc5")

    {:noreply, socket}
  end

  # callback from client pushEvent.... does not work when broadcast ???
  # @impl true
  # def handle_event("ssr", %{"inc6" => inc6}, socket) do
  #   socket =
  #     socket
  #     # update_socket(socket, :b6, inc6, "inc6")
  #     |> update(:count, &(&1 + inc6))
  #     |> update(:clicks, &Map.put(&1, :b6, &1[:b6] + 1))
  #     |> update(:count6, &(&1 + 1))

  #   LiveviewCountersWeb.Endpoint.broadcast!(@topic, "inc6", %{message: socket.assigns})
  #   IO.inspect(socket.assigns.count6)
  #   {:reply, %{newCount: socket.assigns.count6}, socket}
  # end

  # alternative to above: client has callback handleEvent
  @impl true
  def handle_event("ssr", %{"inc6" => inc6}, socket) do
    socket =
      socket
      # update_socket(socket, :b6, inc6, "inc6")
      |> update(:count, &(&1 + inc6))
      |> update(:clicks, &Map.put(&1, :b6, &1[:b6] + 1))
      |> update(:count6, &(&1 + 1))

    LiveviewCountersWeb.Endpoint.broadcast!(@topic, "inc6", %{message: socket.assigns})

    {:noreply, push_event(socket, "server", %{newCount: socket.assigns.count6})}
  end

  @impl true
  # click to fetch data from fake button and send notification BTW
  def handle_event("inc7", %{"inc7" => inc7}, socket) do
    socket =
      socket
      # update_socket(socket, :b7, inc7, "inc7")
      |> update(:count, &(&1 + inc7))
      |> update(:clicks, &Map.put(&1, :b7, &1[:b7] + 1))
      |> assign(:display_data, socket.assigns.data)

    LiveviewCountersWeb.Endpoint.broadcast!(@topic, "inc7", %{message: socket.assigns})

    {:noreply, push_event(socket, "notif", %{msg: "data here!"})}
  end

  @impl true
  #
  def handle_info(%{inc3: inc3, int: int}, socket) do
    socket =
      socket
      # update_socket(socket, :b7, inc7, "inc7")
      |> update(:count, &(&1 + String.to_integer(inc3)))
      |> update(:clicks, &Map.put(&1, :b3, &1[:b3] + 1))
      |> assign(int: int)

    LiveviewCountersWeb.Endpoint.broadcast!(@topic, "inc3", %{message: socket.assigns})
    {:noreply, push_event(socket, "test", %{info: "test"})}
  end

  # @impl true
  # push_event to update the live_button counter
  def handle_info(
        %Phoenix.Socket.Broadcast{event: _event, payload: %{message: message}, topic: @topic},
        socket
      ) do
    {:noreply,
     push_event(
       socket
       |> assign(
         count: message.count,
         clicks: message.clicks,
         count6: message.count6,
         data: message.data,
         display_data: message.display_data,
         prefetching: message.prefetching,
         int: message.int
       ),
       "server",
       %{newCount: message.count6}
     )}
  end
end
