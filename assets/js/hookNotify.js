function sendNotification(msg, user) {
  const notification = new Notification('New message from Open Chat', {
    icon: 'https://cdn-icons-png.flaticon.com/512/733/733585.png',
    body: `@${user}: ${msg}`,
  });
  notification.onclick = () => console.log('ok!');
}

export const Notify = {
  mounted() {
    // don't ask user for notification permission on mount but only if one pushes this first notification
    this.handleEvent('notif', ({ msg }) => {
      if (!('Notification' in window)) return;
      Notification.requestPermission(permission => {
        if (!Notification.permission === 'granted') return;
        msg === undefined ? (msg = 'hi') : msg;
        sendNotification(msg, 'you');
      });
    });
  },
};
