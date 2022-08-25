import React from 'react';
import { MapContainer, TileLayer } from 'react-leaflet';
import { gps, useSnapshot } from './geoLocate';

export function MapComponent() {
  const { currentPos } = useSnapshot(gps);
  return (
    <>
      {currentPos.lat && (
        <MapContainer
          center={[currentPos.lat, currentPos.lng]}
          zoom={10}
          class='leaftet-container'
        >
          <TileLayer
            url='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
            attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
          />
        </MapContainer>
      )}
    </>
  );
}
