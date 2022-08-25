import { proxy, useSnapshot } from 'valtio';
import { derive } from 'valtio/utils';

const gps = proxy({
  initPos: { lat: 45, lng: 0 },
  currentPos: { lat: null, lng: null },
});

derive({
  derPos: async get => {
    if (!navigator.geolocation) return get(gps).initPos;

    navigator.geolocation.getCurrentPosition(success, fail);
    function fail(e) {
      return e;
    }
    function success({ coords: { latitude, longitude } }) {
      get(gps).currentPos = { lat: latitude, lng: longitude };
    }
  },
});

export { gps, useSnapshot };
