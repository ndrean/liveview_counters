// import React from 'react';

// import { MapContainer } from 'react-leaflet/MapContainer';
// import { Marker } from 'react-leaflet/Marker';
// import { Popup } from 'react-leaflet/Popup';
// import { TileLayer } from 'react-leaflet/TileLayer';
// import { useMapEvents, useMap } from 'react-leaflet/hooks';

// import * as ELG from 'esri-leaflet-geocoder';
// import { GeoSearchControl } from 'leaflet-geosearch';
// import { EsriProvider } from 'leaflet-geosearch';

// import L from 'leaflet';
// import icon from 'leaflet/dist/images/marker-icon.png';
// import iconShadow from 'leaflet/dist/images/marker-shadow.png';

// let DefaultIcon = L.icon({
//   iconUrl: icon,
//   shadowUrl: iconShadow,
// });
// L.Marker.prototype.options.icon = DefaultIcon;

// // import { gps, useSnapshot } from './geoLocate';

// function ReverseGeoLoc() {
//   const map = useMap();
//   const geocoder = L.Control.Geocoder.addTo(map);
//   let marker;

//   map.on('click', e => {
//     geocoder.reverse(
//       e.latlng,
//       map.options.crs.scale(map.getZoom()),
//       results => {
//         var r = results[0];
//         if (r) {
//           if (marker) {
//             marker
//               .setLatLng(r.center)
//               .setPopupContent(r.html || r.name)
//               .openPopup();
//           } else {
//             marker = L.marker(r.center)
//               .bindPopup(r.name)
//               .addTo(map)
//               .openPopup();
//           }
//         }
//       }
//     );
//   });
// }

// export function MapComponent() {
//   /*
//   const {
//     currentPos: { lat, lng },
//   } = useSnapshot(gps);
//   */
//   let lat = 45;
//   let lng = 55;

//   return (
//     <>
//       {lat && (
//         <MapContainer center={[lat, lng]} zoom={5} class='leaftet-container'>
//           <TileLayer
//             url='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
//             attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
//           ></TileLayer>
//           <GeoSearchComponent />
//           <GeoHomeMarker />
//           <Marker position={[lat, lng]}>
//             <Popup>Initial position</Popup>
//           </Marker>
//         </MapContainer>
//       )}
//     </>
//   );
// }

// function GeoHomeMarker() {
//   const [position, setPosition] = React.useState(null);
//   const map = useMapEvents({
//     click() {
//       map.locate();
//     },
//     locationfound(e) {
//       setPosition(e.latlng);
//       map.flyTo(e.latlng, map.getZoom());
//     },
//   });
//   return position === null ? null : (
//     <Marker position={position}>
//       <Popup>You are here</Popup>
//     </Marker>
//   );
// }

// function html({ lat, lng, Match_addr }) {
//   if (!Match_addr) {
//     return `
//         <h3>Lat: ${lat.toFixed(3)}</h3>
//         <h3>Lng: ${lng.toFixed(3)}</h3>
//         <button type="button" class="remove">Remove</button>
//         <button type="button" class="reverse">Reverse</button>
//         `;
//   } else {
//     return `
//         <h3>Lat: ${lat.toFixed(3)}</h3>
//         <h3>Lng: ${lng.toFixed(3)}</h3>
//         <p>${Match_addr}</p>
//         `;
//   }
// }

// function GeoSearchComponent() {
//   const map = useMap();
//   map.addControl(searchControl(map));
// }

// function searchControl(map) {
//   const provider = new EsriProvider();
//   return new GeoSearchControl({
//     provider: provider,
//     style: 'button',
//     notFoundMessage: 'Sorry, that address could not be found.',
//   });
// }
