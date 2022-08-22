export const Hover = {
  mounted() {
    document.getElementById('b10').addEventListener('mouseenter', e => {
      e.target.style.cursor = 'progress';
      this.pushEvent('prefetch', {});
    });
  },
};
