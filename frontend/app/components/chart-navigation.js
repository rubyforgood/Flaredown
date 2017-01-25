import Ember from 'ember';

const {
  $,
  Component,
  computed,
  get,
  getOwner,
  computed: { alias },
} = Ember;

export default Component.extend({
  date: new Date(),
  dateFormat: 'MMM D',
  classNames: ['chart-navigation'],

  visibleChartsCount: alias('chartsVisibilityService.visibleChartsCount'),

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
    openFilter() {
      getOwner(this)
        .lookup('route:application')
        .send('openModal', 'modals/charts-filter');
    },

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
