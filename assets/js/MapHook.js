import L from 'leaflet';
import { geocoder } from 'leaflet-control-geocoder';
import icon from 'leaflet/dist/images/marker-icon.png';
import iconShadow from 'leaflet/dist/images/marker-shadow.png';
import { proxy, subscribe } from 'valtio';

let DefaultIcon = L.icon({
  iconUrl: icon,
  shadowUrl: iconShadow,
  iconAnchor: [10, 10],
  // iconAnchor: [10, 0],
});
L.Marker.prototype.options.icon = DefaultIcon;

function getLocation(map) {
  navigator.geolocation.getCurrentPosition(locationfound, locationdenied);
  function locationfound({ coords: { latitude: lat, longitude: lng } }) {
    map.flyTo([lat, lng], 12);
  }
  function locationdenied() {
    window.alert('location access denied');
  }
}

const place = proxy({ coords: [], distance: 0 });

export const MapHook = {
  mounted() {
    const map = L.map('map').setView([45, 0], 10);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 20,
      attribution: '© OpenStreetMap',
    }).addTo(map);

    getLocation(map);
    const layerGroup = L.layerGroup().addTo(map);
    const lineLayer = L.layerGroup().addTo(map);

    const geoCoder = L.Control.Geocoder.nominatim();

    const coder = L.Control.geocoder({
      defaultMarkGeocode: false,
    }).addTo(map);

    coder.on('markgeocode', function ({ geocode: { center, html, name } }) {
      html = addButton(html);
      const marker = L.marker(center, { draggable: true })
        .addTo(layerGroup)
        .bindPopup(html);
      map.flyTo(center, 17);

      const location = {
        id: marker._leaflet_id,
        lat: center.lat,
        lng: center.lng,
        name,
      };

      if (place.coords.find(c => c.id === location.id) === undefined)
        place.coords.push(location);

      marker.on('popupopen', () => openMarker(marker, location.id));
      marker.on('dragend', () => draggedMarker(marker, location.id, lineLayer));
    });

    map.invalidateSize({ debounceMoveend: true }).on('moveend', function () {
      console.log(map.getBounds());
    });

    subscribe(place, () => {
      this.pushEvent('add_point', { place });
    });

    function drawLine() {
      const [start, end, ...rest] = place.coords;
      if (!start || !end) lineLayer.clearLayers();
      if (start && end) {
        const p1 = L.latLng([start.lat, start.lng]);
        const p2 = L.latLng([end.lat, end.lng]);
        console.log('draw: ', { p1, p2 });
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
        layerGroup.removeLayer(marker);
        lineLayer.clearLayers();
        place.distance = 0;
        if (place.coords.length >= 2) {
          drawLine();
        }
      });
    }

    function addButton(html = '') {
      return `<h5>${html}</h5>
              <button type="button" class="remove" >Remove</button>`;
    }

    function draggedMarker(mark, id, lineLayer) {
      document.querySelector('.leaflet-interactive').remove();
      layerGroup.removeLayer(mark);
      const newLatLng = mark.getLatLng();
      const marker = L.marker(newLatLng, { draggable: true });
      marker.addTo(layerGroup);
      const index = place.coords.findIndex(c => c.id === id);
      discover(marker, newLatLng, index, id);

      marker.on('popupopen', () => openMarker(marker, id));
      marker.on('dragend', () => draggedMarker(marker, id, lineLayer));
    }

    function discover(marker, newLatLng, index, id) {
      geoCoder.reverse(newLatLng, 12, result => {
        let { html, name } = result[0];
        place.coords[index] = {
          name,
          id,
          lat: newLatLng.lat.toFixed(4),
          lng: newLatLng.lng.toFixed(4),
        };
        if (place.coords.length == 2) drawLine();
        html = addButton(html);
        return marker.bindPopup(html);
      });
    }

    map.on('click', e => {
      geoCoder.reverse(e.latlng, 12, result => {
        let { html, name } = result[0];
        html = addButton(html);
        const marker = L.marker(e.latlng, { draggable: true });
        marker.addTo(layerGroup).bindPopup(html);
        const location = {
          id: marker._leaflet_id,
          lat: e.latlng.lat.toFixed(4),
          lng: e.latlng.lng.toFixed(4),
          name,
        };

        if (place.coords.find(c => c.id === location.id) === undefined) {
          place.coords.push(location);
          drawLine(lineLayer);
        }
        marker.on('popupopen', () => openMarker(marker, location.id));
        marker.on('dragend', () =>
          draggedMarker(marker, location.id, lineLayer)
        );
      });
    });

    this.handleEvent('add', ({ coords: [lat, lng] }) => {
      const coords = L.latLng([Number(lat), Number(lng)]);
      const marker = L.marker(coords);
      marker.addTo(layerGroup).bindPopup(addButton());
      marker.on('popupopen', () => openMarker(marker, marker._leaflet_id));
    });
  },
};
