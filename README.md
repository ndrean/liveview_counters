# LiveviewCounters

LiveView components (function, live, hooks, react, JS.push & prefetch)

See explanations [dev.to](https://dev.to/ndrean/notes-on-liveview-components-and-js-interactions-22gh)

> `wait_for_it`: to test with?

## Esbuild

[loader for png/dataUrl](https://esbuild.github.io/api/#loader)

npm i leaflet-control-geocoder

Checkout <https://github.com/eJuke/Leaflet.Canvas-Markers> using canvas instead of DOM

Icons: <https://ionic.io/ionicons>,

- Load geoJSON without server: leaflet-geojson-vt
- check maptiler to create tiles in the cloud and convert to geojson
- use canvas instead of the DOM to render marker (faster) with <https://github.com/francoisromain/leaflet-markers-canvas>

attribute :id, :uuid do
primary_key? true
default &Ecto.UUID.generate/0

<button id="test" phx-click={JS.dispatch("push-test", detail: %{"hooks" => "MapHook_map-ButtonHook_click", nodes => node1_evt1-node2_evt2})}>Push</button>

window.addEventListener('push-test', ({ detail: { hooks, nodes } }) => {
  hooks
  .split('-')
  .map(e => e.split('_'))
  .forEach(([hook, fun]) => {
    eval(`${hook}.${fun}()`);
  });

  nodes
  .parse
  .forEach(([node, evt])=>{
    document
    .getElementById(node)
    .dispatchEvent(new Event(evt))
});
