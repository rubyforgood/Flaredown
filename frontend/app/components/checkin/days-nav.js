/* global moment */
import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

export default Ember.Component.extend(CheckinByDate, {

  classNames: ['checkin-days-nav'],
  classNameBindings: ['big'],

  currentDate: Ember.computed.alias('checkin.date'),
  monthAndDay: Ember.computed('currentDate', function() {
    return moment(this.get('currentDate')).format("MMMM Do");
  }),
  isToday: Ember.computed('currentDate', function() {
    return moment(this.get('currentDate')).isSame(new Date(), 'day');
  }),
  isntToday: Ember.computed.not('isToday'),

  store: Ember.inject.service(),

  actions: {
    goToYesterday() {
      var yesterday = moment(this.get('currentDate')).subtract(1, 'days');
      this.routeToCheckin(yesterday.format("YYYY-MM-DD"), this.get('step.key'));
    },
    goToTomorrow() {
      if (this.get('isntToday')) {
        var tomorrow = moment(this.get('currentDate')).add(1, 'days');
        this.routeToCheckin(tomorrow.format("YYYY-MM-DD"), this.get('step.key'));
      }
    }
  }

});
