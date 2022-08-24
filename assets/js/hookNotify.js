function sendNotification(msg, user) {
  const notification = new Notification('New message:', {
    icon: 'https://cdn-icons-png.flaticon.com/512/733/733585.png',
    body: `@${user}: ${msg}`,
  });
  console.log('notification sent');
  notification.onclick = () => console.log('ok!');
  setTimeout(() => {
    notification.close();
  }, 2_000);
}

const showError = () => window.alert('Notifications are blocked');

export const Notify = {
  mounted() {
    // don't ask user for notification permission on mount but only if one pushes this first notification
    this.handleEvent('notif', ({ msg }) => {
      if (!('Notification' in window)) {
        return showError();
      }

      (async () => {
        await Notification.requestPermission(permission => {
          msg === undefined ? (msg = 'hi there') : msg;

          return permission === 'granted'
            ? sendNotification(msg, 'you')
            : showError();
        });
      })();
    });
  },
};
