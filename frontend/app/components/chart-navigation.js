import Ember from 'ember';

const {
  $,
  Component,
  computed,
  get,
} = Ember;

export default Component.extend({
  date: new Date(),
  dateFormat: 'MMM D',
  classNames: ['chart-navigation'],

  pickadateOptions: {
    container: 'body > .ember-view',
  },

  endAtLabel: computed('endAt', function() {
    return get(this, 'endAt').format(get(this, 'dateFormat'));
  }),

  startAtLabel: computed('startAt', function() {
    return get(this, 'startAt').format(get(this, 'dateFormat'));
  }),

  actions: {
    openPicker() {
      $('.calendar-opener .picker__input').first().pickadate('picker').open();
    },

    navigateLeft() {
      get(this, 'onNavigate')(-1);
    },

    navigateRight() {
      get(this, 'onNavigate')(1);
    },
  },
});
