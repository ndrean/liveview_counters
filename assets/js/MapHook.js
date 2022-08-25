import React from 'react';
import { createRoot } from 'react-dom/client';

export const MapHook = {
  mounted() {
    const container = document.getElementById('map');
    const root = createRoot(container);
    import('./Map.jsx').then(({ MapComponent }) =>
      root.render(
        <React.Suspense fallback={<h1>Loading...</h1>}>
          <MapComponent />
        </React.Suspense>
      )
    );
  },
};
