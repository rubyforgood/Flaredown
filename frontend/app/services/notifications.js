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
      notificateableId,
      notificateableType,
      notificateableParentId,
    } = options;

    get(this, 'notifications')
      .filter(notification => {
        const n = getProperties(
          notification,
          'kind',
          'notificateableId',
          'notificateableType',
          'notificateableParentId'
        );

        return (!kind || n.kind === kind) &&
          (!notificateableId || n.notificateableId === notificateableId) &&
          (!notificateableType || n.notificateableType === notificateableType) &&
          (!notificateableParentId || n.notificateableParentId === notificateableParentId);
      })
      .forEach(n => n.unloadRecord());
  },
});
