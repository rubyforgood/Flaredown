import Ember from 'ember';

const {
  $,
  Component,
  computed,
  get,
  set,
  computed: { alias },
  observer,
} = Ember;

export default Component.extend({
  date: new Date(),
  dateFormat: 'MMM D',
  classNames: ['chart-navigation'],
  patternNavbar: false,

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
    openPicker() {
      const arg = arguments[0];
      let selector = `.calendar-opener-${arg}`;

      $(`${selector} .picker__input`).first().pickadate('picker').open();
    },

    navigateLeft() {
      this.sendAction('onNavigate', -1);
    },

    navigateRight() {
      this.sendAction('onNavigate', 1);
    },

    startChanged(date) {
      this.sendAction('onChangeStartAt', moment(date));
    },

    endChanged(date) {
      this.sendAction('onChangeEndAt', moment(date));
    },
  },
});
