import Ember from 'ember';
import InViewportMixin from 'ember-in-viewport';

const {
  set,
  observer,
  Component,
  getProperties,
  run: {
    schedule,
  },
  inject: {
    service,
  },
} = Ember;

export default Component.extend(InViewportMixin, {
  visited: false,

  ajax: service(),
  notifications: service(),

  didEnterViewport() {
    schedule('afterRender', this, this.setVisited);
  },

  setVisited() {
    set(this, 'visited', true);
  },

  destroyNotifications: observer('visited', 'comment.body', function() {
    const {
      ajax,
      comment,
      visited,
      notifications
    } = getProperties(this, 'ajax', 'comment', 'visited', 'notifications');

    const { id, hasNotifications } = getProperties(comment, 'id', 'hasNotifications');

    if (visited && hasNotifications) {
      ajax
        .del(`notifications/comment/${id}`)
        .then(() => set(comment, 'notifications', {}))
        .then(() => notifications.unloadNotification({ notificateableId: id }));
    }
  }),
});
