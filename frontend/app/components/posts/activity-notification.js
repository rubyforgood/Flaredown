import Ember from 'ember';

const {
  get,
  computed,
  Component,
} = Ember;

export default Component.extend({
  classNames: ['flaredown-white-box'],

  people: computed('notification.count', function() {
    const count = get(this, 'notification.count');

    return `${count} ${count > 1 ? 'people' : 'person'}`;
  }),

  didWhat: computed('notification.kind', function() {
    return get(this, 'notification.kind') === 'comment' ? 'responded' : 'reacted';
  }),
});
