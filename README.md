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
