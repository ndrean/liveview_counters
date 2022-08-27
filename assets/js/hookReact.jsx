// import React from 'react';
// import { createRoot } from 'react-dom/client';
// import { proxy, useSnapshot } from 'valtio';
// import { Spinner } from './Spinner';

// const store = proxy({
//   countSSR: 0,
// });

// const LazyCounter = React.lazy(() => import('./Counters'));

// const ReactHook = {
//   mounted() {
//     const container = document.getElementById('b5');
//     if (!container) return;

//     const inc5 = Number(container.dataset.inc5);
//     const inc6 = Number(container.dataset.inc6);

//     const root = createRoot(container);

//     // import('./Counters.jsx').then(({ Counters }) =>
//     root.render(
//       <React.Suspense fallback={<Spinner />}>
//         <LazyCounter
//           push={c => this.push(c)}
//           ssr={c => this.ssr(c)}
//           inc={inc5}
//           incSSR={inc6}
//         />
//       </React.Suspense>
//     );
//   },
//   push(inc5) {
//     this.pushEvent('inc5', { inc5 });
//   },
//   // with callback from LiveView
//   ssr(inc6) {
//     this.pushEvent('ssr', { inc6 }, ({ newCount }) => {
//       console.log({ newCount });
//       store.countSSR = newCount;
//     });
//   },
// };

// export { store, useSnapshot, React, ReactHook };
