import Ember from 'ember';

const {
  get,
  set,
  Service,
  getProperties,
  inject: {
    service,
  },
  computed: {
    alias,
  },
} = Ember;

export default Service.extend({
  store: service(),
  session: service(),

  count: alias('notifications.length'),
  first: alias('notifications.firstObject'),

  loadNotifications() {
    if (get(this, 'session.isAuthenticated')) {
      return get(this, 'store')
        .findAll('notification')
        .then(notifications => set(this, 'notifications', notifications));
    }
  },

  unloadNotification(options) {
    const {
      kind,
      postId,
      notificateableId,
      notificateableType,
    } = options;

    get(this, 'notifications')
      .filter(notification => {
        const n = getProperties(
          notification,
          'kind',
          'notificateableId',
          'notificateableType',
          'postId'
        );

        return (!kind || n.kind === kind) &&
          (!postId || n.postId === postId) &&
          (!notificateableId || n.notificateableId === notificateableId) &&
          (!notificateableType || n.notificateableType === notificateableType);
      })
      .forEach(n => n.unloadRecord());
  },
});
