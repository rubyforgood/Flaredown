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

  pickadateOptions: {
    container: 'body > .ember-view',
    max: moment().toDate(),
  },

  currentDate: Ember.computed.alias('checkin.date'),

  checkinDate: computed('currentDate', function() {
    return moment(get(this, 'currentDate')).toDate();
  }),

  monthAndDay: Ember.computed('currentDate', function() {
    return moment(this.get('currentDate')).format("MMMM Do");
  }),

  isToday: Ember.computed('currentDate', function() {
    return moment(this.get('currentDate')).isSame(new Date(), 'day');
  }),
  isntToday: Ember.computed.not('isToday'),

  checkinDateLabel: computed('checkinDate', function() {
    return moment(get(this, 'checkinDate')).format('MMM D');
  }),

  actions: {
    goToYesterday() {
      const yesterday = moment(this.get('currentDate')).subtract(1, 'days');

      this.routeToCheckin(yesterday.format("YYYY-MM-DD"), this.get('step.key'));
    },
    goToTomorrow() {
      if (this.get('isntToday')) {
        const tomorrow = moment(this.get('currentDate')).add(1, 'days');

        this.routeToCheckin(tomorrow.format("YYYY-MM-DD"), this.get('step.key'));
      }
    },

    openPicker() {
      this.$('.calendar-opener .picker__input').first().pickadate('picker').open();
    },

    checkinDateChanged(date) {
      const checkinDate = moment(date);

      this.routeToCheckin(checkinDate.format("YYYY-MM-DD"), get(this, 'step.key'));
    },
  }

});
