import Ember from 'ember';

const {
  $,
  Component,
  computed,
  get,
  set,
  computed: { alias },
  observer,
  run: { scheduleOnce }
} = Ember;

export default Component.extend({
  date: new Date(),
  dateFormat: 'MMM D',
  classNames: ['chart-navigation'],
  patternNavbar: false,

  visibleChartsCount: alias('chartsVisibilityService.visibleChartsCount'),

  pickadateOptionsStart: {
    container: 'body > .ember-view',
    max: moment().toDate(),
  },

  pickadateOptionsEnd: {
    container: 'body > .ember-view',
    max: moment().toDate(),
  },

  startDate: computed('startAt', function(){
    return get(this, 'startAt').toDate();
  }),

  endDate: computed('endAt', function(){
    return get(this, 'endAt').toDate();
  }),

  endAtLabel: computed('endAt', function() {
    return get(this, 'endAt').format(get(this, 'dateFormat'));
  }),

  startAtLabel: computed('startAt', function() {
    return get(this, 'startAt').format(get(this, 'dateFormat'));
  }),

  startDateLimitationObserver: observer('endAt', function() {
    set(this, 'pickadateOptionsStart', $.extend({}, get(this, 'pickadateOptionsStart'), {
      max: get(this, 'endAt').toDate()
    }));
  }),

  rigthArrowVisibile: computed('endAt', function() {
    return get(this, 'endAt').endOf('day') < moment();
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
      scheduleOnce('afterRender', this, () => {
        this.sendAction('onChangeStartAt', moment(date));
      });
    },

    endChanged(date) {
      scheduleOnce('afterRender', this, () => {
        this.sendAction('onChangeEndAt', moment(date));
      });
    },
  },
});
