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

  unreadClass: alias('notification.unread'),
});
