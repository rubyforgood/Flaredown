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
  rateOfDuration: 0.2,

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

  DaysDuration: computed('startAt', 'endAt', function() {
    let duration = moment.duration(get(this, 'endAt') - get(this, 'startAt')).asDays();
    let rate = Number(duration*get(this, 'rateOfDuration')).toFixed(0);

    return rate > 1 ? rate : 1;
  }),

  actions: {
    openPicker() {
      const arg = arguments[0];
      let selector = `.calendar-opener-${arg}`;

      $(`${selector} .picker__input`).first().pickadate('picker').open();
    },

    navigateLeft() {
      this.sendAction('onNavigate', -(get(this, 'DaysDuration')));
    },

    navigateRight() {
      this.sendAction('onNavigate', get(this, 'DaysDuration'));
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
