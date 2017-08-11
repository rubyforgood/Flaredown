import Ember from 'ember';
import InViewportMixin from 'ember-in-viewport';
import UpdateNotifications from 'flaredown/mixins/update-notifications';

const {
  get,
  Component,
  run: {
    schedule,
  },
  inject: {
    service,
  },
} = Ember;

export default Component.extend(InViewportMixin, UpdateNotifications, {
  classNames: ['flaredown-white-box post'],

  ajax: service(),
  notifications: service(),
  elipsis: 125,

  didEnterViewport() {
    schedule('afterRender', this, this.updatePostNotifications, get(this, 'post'));
  },
});
