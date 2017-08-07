import Ember from 'ember';
import InViewportMixin from 'ember-in-viewport';

const {
  get,
  set,
  Component,
  getProperties,
  inject: {
    service,
  },
} = Ember;

export default Component.extend(InViewportMixin, {
  classNames: ['flaredown-white-box post'],

  ajax: service(),
  notifications: service(),
  elipsis: 125,

  didEnterViewport() {
    const { ajax, post } = getProperties(this, 'ajax', 'post');

    if (get(post, 'notifications.reaction')) {
      const id = get(post, 'id');
      const store = get(this, 'store');

      ajax
        .put(`notifications/post/${id}`)
        .then(({ notifications }) => {
          notifications.forEach((n) => {
            const model = store.peekRecord('notification', n.id);

            if(model){
              set(model, 'unread', false);
            }
          });
          set(post, 'notifications', {});
        });
    }
  },
});
