import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

const {
  $,
  get,
  set,
  computed,
  Component,
} = Ember;

export default Component.extend(CheckinByDate, {
  classNames: ['checkin-head-nav'],
  classNameBindings: ['big'],

  checkinDate: moment(),

  pickadateOptions: {
    container: 'body > .ember-view',
    max: moment().toDate(),
  },

  currentDate: Ember.computed.alias('checkin.date'),
  monthAndDay: Ember.computed('currentDate', function() {
    return moment(this.get('currentDate')).format("MMMM Do");
  }),

  isToday: Ember.computed('currentDate', function() {
    return moment(this.get('currentDate')).isSame(new Date(), 'day');
  }),
  isntToday: Ember.computed.not('isToday'),

  checkinDateLabel: computed('checkinDate', function() {
      const checkinDate = get(this, 'checkinDate') || get(this, 'currentDate');

      return moment(checkinDate).format('MMM D');
  }),

  actions: {
    goToYesterday() {
      const yesterday = moment(this.get('currentDate')).subtract(1, 'days');
      set(this, 'checkinDate', yesterday);

      this.routeToCheckin(yesterday.format("YYYY-MM-DD"), this.get('step.key'));
    },
    goToTomorrow() {
      if (this.get('isntToday')) {
        const tomorrow = moment(this.get('currentDate')).add(1, 'days');
        set(this, 'checkinDate', tomorrow);

        this.routeToCheckin(tomorrow.format("YYYY-MM-DD"), this.get('step.key'));
      }
    },

    openPicker() {
      $('.calendar-opener .picker__input').first().pickadate('picker').open();
    },

    checkinDateChanged(date) {
      const checkinDate = moment(date);
      set(this, 'checkinDate', checkinDate);

      this.routeToCheckin(checkinDate.format("YYYY-MM-DD"), get(this, 'step.key'));
    },
  }

});
