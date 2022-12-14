import { store, useSnapshot, React } from './hookReact';

export const Counters = ({ push, ssr, inc, incSSR }) => {
  const [value, setValue] = React.useState(0);
  const { countSSR } = useSnapshot(store);

  const action = () => {
    setValue(value => value + 1);
    push(inc);
  };

  return (
    <>
      <button onClick={action}>
        Stateful React: +{inc}, <span>Clicked: {value}</span>
      </button>
      <br />
      <button onClick={() => ssr(incSSR)}>
        Stateless React: +{incSSR}, Clicked: {countSSR}
      </button>
    </>
  );
};
