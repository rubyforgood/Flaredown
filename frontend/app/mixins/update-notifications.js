import Ember from 'ember';

const {
  get,
  set,
  inject: {
    service,
  },
  Mixin
} = Ember;

export default Mixin.create({
  ajax: service(),
  notifications: service(),
  store: service(),

  updatePostNotifications(post) {
    const ajax = get(this, 'ajax');

    if (get(post, 'notifications.reaction') && get(this, 'updateNotifications')) {
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
  }
});
