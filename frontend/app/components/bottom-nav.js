import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['bottom-nav'],

  isCheckinPath: Ember.computed('router.url', function() {
    return this.get('router.url').split('/')[1] === 'checkin';
  }),

  checkinNavClass: Ember.computed('isCheckinPath', function() {
    return `bottom-link ${this.get('isCheckinPath') ? 'active' : ''}`;
  }),
});
