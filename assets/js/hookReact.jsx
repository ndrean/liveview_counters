import React from 'react';
import { createRoot } from 'react-dom/client';
import { proxy, useSnapshot, subscribe } from 'valtio';

const store = proxy({ countSSR: 0 });

const ReactHook = {
  mounted() {
    const container = document.getElementById('b5');
    if (!container) return;

    const inc5 = Number(container.dataset.inc5);
    const inc6 = Number(container.dataset.inc6);

    /*
    this.handleEvent('server', ({ newCount }) => {
      console.log({ newCount });
      store.countSSR = newCount;
    });
    */

    subscribe(store, () => {
      console.log('Store updated!: ', store.countSSR);
    });

    import('./Counters.jsx').then(({ Counters }) =>
      createRoot(container).render(
        <Counters
          push={c => this.push(c)}
          ssr={c => this.ssr(c)}
          inc={inc5}
          incSSR={inc6}
        />
      )
    );
  },
  push(inc5) {
    this.pushEvent('inc5', { inc5 });
  },
  // ssr : with callback from LiveView, ssr2, with handleEvent above
  ssr(inc6) {
    this.pushEvent(
      'ssr',
      { inc6 },
      ({ newCount }) => (store.countSSR = newCount)
    );
  },
};

export { store, useSnapshot, React, ReactHook };
