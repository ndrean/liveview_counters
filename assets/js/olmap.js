// // import ol from 'openlayers';
// // @import 'ol/ol.css' in App.css

// import Map from 'ol/Map';
// import View from 'ol/View';
// import { Vector as VectorSource } from 'ol/source';
// import OSM, { ATTRIBUTION } from 'ol/source/OSM';
// import { Tile as TileLayer, Vector as VectorLayer } from 'ol/layer';
// import { Projection, useGeographic } from 'ol/proj';
// import DragAndDrop from 'ol/interaction/DragAndDrop';
// import { Modify, Draw, Snap } from 'ol/interaction';
// import { Circle as CircleStyle, Fill, Stroke, Style } from 'ol/style';
// import Overlay from 'ol/Overlay';
// import { toStringHDMS } from 'ol/coordinate';

// export const OlMap = {
//   mounted() {
//     useGeographic(); // => lon, lat
//     const openSeaMapLayer = new TileLayer({
//       source: new OSM({
//         attributions: [
//           'All maps © <a href="https://www.openseamap.org/">OpenSeaMap</a>',
//           ATTRIBUTION,
//         ],
//         opaque: false,
//         url: 'https://tiles.openseamap.org/seamark/{z}/{x}/{y}.png',
//       }),
//     });

//     /**
//      * Elements that make up the popup.
//      */
//     const container = document.getElementById('popup');
//     const content = document.getElementById('popup-content');
//     const closer = document.getElementById('popup-closer');

//     /**
//      * Create an overlay to anchor the popup to the map.
//      */
//     const overlay = new Overlay({
//       element: container,
//       autoPan: {
//         animation: {
//           duration: 250,
//         },
//       },
//     });

//     /**
//      * Add a click handler to hide the popup.
//      * @return {boolean} Don't follow the href.
//      */
//     // closer.onclick = function () {
//     //   overlay.setPosition(undefined);
//     //   closer.blur();
//     //   return false;
//     // };

//     const map = new Map({
//       target: 'olmap',
//       layers: [new TileLayer({ source: new OSM() }), openSeaMapLayer],
//       view: new View({
//         center: [0, 45],
//         zoom: 5,
//       }),
//       overlays: [overlay],
//     });

//     /**
//      * Add a click handler to the map to render the popup.
//      */
//     map.on('singleclick', function (evt) {
//       const coordinate = evt.coordinate;
//       const hdms = toStringHDMS(coordinate);
//       console.log(coordinate, hdms);

//       content.innerHTML = '<p>You clicked here:</p><code>' + hdms + '</code>';
//       overlay.setPosition(coordinate);
//     });

//     const source = new VectorSource();
//     const vector = new VectorLayer({
//       source: source,
//       style: new Style({
//         fill: new Fill({
//           color: 'rgba(255, 255, 255, 0.2)',
//         }),
//         stroke: new Stroke({
//           color: '#ffcc33',
//           width: 2,
//         }),
//         image: new CircleStyle({
//           radius: 7,
//           fill: new Fill({
//             color: '#ffcc33',
//           }),
//         }),
//       }),
//     });
//     map.addLayer(vector);

//     const modify = new Modify({
//       source: source,
//     });
//     map.addInteraction(modify);

//     let draw, snap;
//     function addInteractions() {
//       draw = new Draw({
//         source: source,
//         type: 'Point',
//       });
//       map.addInteraction(draw);
//       snap = new Snap({ source: source });
//       map.addInteraction(snap);
//     }

//     // addInteractions();
//   },
// };
