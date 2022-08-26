import L from 'leaflet';
import icon from 'leaflet/dist/images/marker-icon.png';
import iconShadow from 'leaflet/dist/images/marker-shadow.png';

let DefaultIcon = L.icon({
  iconUrl: icon,
  shadowUrl: iconShadow,
});
L.Marker.prototype.options.icon = DefaultIcon;

import { geocoder } from 'leaflet-control-geocoder';

function getLocation(map) {
  navigator.geolocation.getCurrentPosition(locationfound, locationdenied);
  function locationfound({ coords: { latitude: lat, longitude: lng } }) {
    map.flyTo([lat, lng], 15);
    return true;
  }
  function locationdenied() {
    window.alert('location access denied');
    return null;
  }
}

const place = { coords: [], distance: 0 };

export const MapHook = {
  mounted() {
    const map = L.map('map').setView([45, 0], 10);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '© OpenStreetMap',
    }).addTo(map);

    getLocation(map);
    const layerGroup = L.layerGroup().addTo(map);
    const lineLayer = L.layerGroup().addTo(map);
    const geoCoder = L.Control.Geocoder.nominatim();

    L.Control.geocoder({
      defaultMarkGeocode: false,
    })
      .on('markgeocode', function ({ geocode: { center, html, name } }) {
        // console.log(e);
        html = addButton(html);
        const marker = L.marker(center, { draggable: true })
          .addTo(layerGroup)
          .bindPopup(html);
        map.flyTo(center, 15);

        const location = {
          id: marker._leaflet_id,
          lat: center.lat,
          lng: center.lng,
          name,
        };

        if (place.coords.find(c => c.id === location.id) === undefined)
          place.coords.push(location);

        marker.on('popupopen', () => openMarker(marker, location.id));
        marker.on('dragend', () =>
          draggedMarker(marker, location.id, lineLayer)
        );
      })
      .addTo(map);

    function drawLine() {
      const [start, end, ...rest] = place.coords;
      if (!start || !end) lineLayer.clearLayers();
      if (start && end) {
        const p1 = L.latLng([start.lat, start.lng]);
        const p2 = L.latLng([end.lat, end.lng]);

        L.polyline(
          [
            [start.lat, start.lng],
            [end.lat, end.lng],
          ],
          { color: 'red' }
        ).addTo(lineLayer);

        place.distance = (p1.distanceTo(p2) / 1000).toFixed(2);
      }
    }

    function openMarker(marker, id) {
      document.querySelector('button.remove').addEventListener('click', () => {
        place.coords = place.coords.filter(c => c.id !== id) || [];
        place.distance = 0;
        layerGroup.removeLayer(marker);
        if (place.coords.findIndex(c => c.id === id) < 2)
          lineLayer.clearLayers();
        drawLine();
      });
    }

    function addButton(html) {
      return `<h5>${html}</h5>
              <button type="button" class="remove" >Remove</button>`;
    }

    function draggedMarker(mark, id, lineLayer) {
      document.querySelector('.leaflet-interactive').remove();
      layerGroup.removeLayer(mark);
      const newLatLng = mark.getLatLng();
      const marker = L.marker(newLatLng, { draggable: true });
      marker.addTo(layerGroup).addTo(map);
      const draggedPlace = place.coords.find(c => c.id === id);
      draggedPlace.lat = newLatLng.lat;
      draggedPlace.lng = newLatLng.lng;
      drawLine();
      discover(marker, newLatLng, id);
      marker.on('popupopen', () => openMarker(marker, id));
      marker.on('dragend', () => draggedMarker(marker, id, lineLayer));
    }

    function discover(marker, location, id) {
      // return new Promise((resolve, _) => {
      // resolve(
      geoCoder.reverse(location, 12, result => {
        let { html, name } = result[0];
        place.coords = place.coords.filter(c => c.id !== id);
        place.coords.push({
          name,
          lat: location.lat,
          lng: location.lng,
          id,
        });

        html = addButton(html);
        return marker.bindPopup(html);
      });
      // );
      // });
    }

    map.on('click', e => {
      geoCoder.reverse(e.latlng, 12, result => {
        let { html, name } = result[0];
        html = addButton(html);

        const marker = L.marker(e.latlng, { draggable: true });
        marker.addTo(layerGroup).addTo(map).bindPopup(html);

        const location = {
          id: marker._leaflet_id,
          lat: e.latlng.lat,
          lng: e.latlng.lng,
          name,
        };

        if (place.coords.find(c => c.id === location.id) === undefined)
          place.coords.push(location);

        drawLine(lineLayer);
        marker.on('popupopen', () => openMarker(marker, location.id));
        marker.on('dragend', () =>
          draggedMarker(marker, location.id, lineLayer)
        );
      });
    });
  },
};
