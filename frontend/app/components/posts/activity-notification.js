import Ember from 'ember';

const {
  get,
  computed,
  computed: {
    alias,
  },
  Component,
} = Ember;

export default Component.extend({
  classNames: ['flaredown-white-box'],
  classNameBindings: ['unreadClass:unreadNotification'],

  people: computed('notification.count', function() {
    const count = get(this, 'notification.count');

    return `${count} ${count > 1 ? 'people' : 'person'}`;
  }),

  didWhat: computed('notification.kind', function() {
    return get(this, 'notification.kind') === 'comment' ? 'responded' : 'reacted';
  }),

  fullResponse: computed('people', 'notification.kind', 'notification.notifier_username', function() {
    if(get(this, 'notification.kind') === 'mention') {

      return (`<b>${get(this, 'notification.notifier_username')}</b> mentioned you in a comment` ).htmlSafe();
    } else {
      let response = get(this, 'notification.kind') === 'comment' ? 'responded' : 'reacted';

      return (`<b>${get(this, 'people')}</b> ${response} to ${get(this, 'notification.postTitle')}`).htmlSafe();
    }
  }),

  unreadClass: alias('notification.unread'),
});
