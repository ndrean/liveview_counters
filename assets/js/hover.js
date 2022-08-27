export const Hover = {
  mounted() {
    const button = document.getElementById('b10');
    if (!button) return;

    button.addEventListener('mouseenter', e => {
      e.target.style.cursor = 'progress';
      this.pushEvent('prefetch', {});
    });
  },
};
