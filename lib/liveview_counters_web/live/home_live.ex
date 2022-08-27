defmodule LiveviewCountersWeb.HomeLive do
  use Phoenix.LiveView
  # alias Phoenix.LiveView.JS
  require WaitForIt
  require Logger

  # @topic "counters"
  # @topic inspect(__MODULE__)

  @impl true
  def mount(_, _, socket) do
    if connected?(socket), do: Logger.debug(socket, label: "parent")
    # Phoenix.PubSub.subscribe(LiveviewCountersWeb.PubSub, @topic)
    # LiveviewCountersWeb.Endpoint.subscribe(@topic)

    {:ok,
     assign(socket,
       count: 0,
       prefetching: false,
       count6: 0,
       clicks: %{b1: 0, b2: 0, b3: 0, b4: 0, b5: 0, b6: 0, b7: 0},
       data: nil,
       display_data: nil,
       place: nil
     )}
  end

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <MyMap.display />
    <Table.display place={@place}/>

    <button id="marker" phx-click="push_marker" phx-value-lat={"47.2"} phx-value-lng={"-1.6"}>Marker</button>
    <button id="b1"  phx-click="inc1" phx-value-inc1={1}>Increment: +1</button>
    <SimpleCounter.display inc2={10} />
    <.live_component module={LiveButton} id="b3" inc3={100} int={0}/>
    <HookButton.display inc4={1000}/>
    <HoverComp.display inc7={1_000_000}/>
    <h1>Counter: <%= @count %></h1>
    <h3><%# Jason.encode!(@clicks) %></h3>
    <h3><%# if @display_data != nil, do: Jason.encode!(elem(@display_data,1)) %></h3>
    """
  end

  # <ReactButtons.display inc5={10_000} inc6={100_000}/>
  # <div id="olmap" style="width: 100%, height: 400px" phx-hook="OlMap"></div>
  # <div id="popup" class="ol-popup">
  #   <a href="#" id="popup-closer" class="ol-popup-closer"></a>
  #   <div id="popup-content"></div>
  # </div>

  defp update_socket(socket, key, inc) do
    socket
    |> update(:count, &(&1 + inc))
    |> update(:clicks, &Map.put(&1, key, &1[key] + 1))
  end

  def handle_event("push_marker", %{"lat" => lat, "lng" => lng}, socket) do
    coords = [lat, lng]
    {:noreply, push_event(socket, "add", %{"coords" => coords})}
  end

  @impl true
  def handle_event("add_point", %{"place" => place}, socket) do
    {:noreply, socket |> assign(:place, place)}
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

  @impl true
  def handle_event("ssr", %{"inc6" => inc6}, socket) do
    socket =
      update_socket(socket, :b6, inc6)
      |> update(:count6, &(&1 + 1))

    {:reply, %{newCount: socket.assigns.count6}, socket}
  end

  @impl true
  def handle_event("inc7", %{"inc7" => inc7}, socket) do
    socket =
      update_socket(socket, :b7, inc7)
      |> assign(:display_data, socket.assigns.data)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{inc3: inc3}, socket) do
    socket = update_socket(socket, :b3, String.to_integer(inc3))

    {:noreply, socket}
  end
end
