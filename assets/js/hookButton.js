export const ButtonHook = {
  mounted() {
    const button = document.getElementById('b4');
    if (!button) return;

    const inc4 = Number(button.dataset.inc4);
    button.addEventListener('click', () => {
      this.pushEvent('inc4', { inc4 });
    });
  },
};
