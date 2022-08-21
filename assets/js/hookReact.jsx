import React from 'react';
import { createRoot } from 'react-dom/client';
import { Counters } from './Counters';
import { proxy, useSnapshot } from 'valtio';

const store = proxy({
  countSSR: 0,
});

const ReactHook = {
  mounted() {
    const container = document.getElementById('b5');
    if (!container) return;

    inc5 = Number(container.dataset.inc5);

    createRoot(container).render(
      <Counters push={c => this.push(c)} ssr={() => this.ssr()} inc={inc5} />
    );
  },
  push(inc5) {
    this.pushEvent('inc5', { inc5 });
  },
  // with callback from LiveView
  ssr() {
    this.pushEvent('ssr', {}, ({ newCount }) => {
      store.countSSR = newCount;
    });
  },
};

export { store, useSnapshot, React, ReactHook };
