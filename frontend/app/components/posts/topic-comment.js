import Ember from 'ember';
import InViewportMixin from 'ember-in-viewport';

const {
  set,
  Component,
  getProperties,
  inject: {
    service,
  },
} = Ember;

export default Component.extend(InViewportMixin, {
  classNames: ['flaredown-white-box'],

  ajax: service(),
  notifications: service(),

  didEnterViewport() {
    const { ajax, comment, notifications } = getProperties(this, 'ajax', 'comment', 'notifications');
    const { id, hasNotifications } = getProperties(comment, 'id', 'hasNotifications');

    if (hasNotifications) {
      ajax
        .del(`notifications/comment/${id}`)
        .then(() => set(comment, 'notifications', {}))
        .then(() => notifications.unloadNotification({ notificateableId: id }));
    }
  },
});
