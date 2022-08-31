defmodule LiveviewCountersWeb.MapLive do
  use Phoenix.LiveView
  # alias Phoenix.LiveView.JS
  require Logger

  # @topic "counters"
  # @topic inspect(__MODULE__)

  @impl true
  def mount(_, _, socket) do
    if connected?(socket), do: Logger.debug(socket, label: "parent")
    # Phoenix.PubSub.subscribe(LiveviewCountersWeb.PubSub, @topic)
    # LiveviewCountersWeb.Endpoint.subscribe(@topic)

    {:ok, assign(socket, place: nil)}
  end

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
        <button id="marker" phx-click="push_marker" phx-value-lat={"47.2"} phx-value-lng={"-1.6"}>Marker</button>

    <MyMap.display />
    <Table.display place={@place}/>

    <footer><a target="_blank" href="https://icons8.com/icon/38130/online">Online</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a></footer>
    """
  end

  # <div id="olmap" style="width: 100%, height: 400px" phx-hook="OlMap"></div>
  # <div id="popup" class="ol-popup">
  #   <a href="#" id="popup-closer" class="ol-popup-closer"></a>
  #   <div id="popup-content"></div>
  # </div>

  def handle_event("push_marker", %{"lat" => lat, "lng" => lng}, socket) do
    coords = [lat, lng]
    {:noreply, push_event(socket, "add", %{"coords" => coords})}
  end

  @impl true
  def handle_event("add_point", %{"place" => place}, socket) do
    {:noreply, socket |> assign(:place, place)}
  end
end
