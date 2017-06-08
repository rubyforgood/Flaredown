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
    } = getProperties(this, 'ajax', 'comment', 'visited');

    const { id, hasNotifications } = getProperties(comment, 'id', 'hasNotifications');

    if (visited && hasNotifications) {
      ajax
        .put(`notifications/comment/${id}`)
        .then(() => set(comment, 'notifications', {}));
    }
  }),
});
