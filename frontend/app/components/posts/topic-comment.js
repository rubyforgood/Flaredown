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

  didEnterViewport() {
    const { ajax, comment } = getProperties(this, 'ajax', 'comment');
    const { id, hasNotifications } = getProperties(comment, 'id', 'hasNotifications');

    if (hasNotifications) {
      ajax
        .put(`notifications/comment/${id}`)
        .then(() => set(comment, 'notifications', {}));
    }
  },
});
