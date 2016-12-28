import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

export default Ember.Component.extend(CheckinByDate, {
  classNames: ['bottom-nav'],

  isCheckinPath: Ember.computed('router.url', function() {
    return this.get('router.url').split('/')[1] === 'checkin';
  }),

  checkinNavClass: Ember.computed('isCheckinPath', function() {
    return `bottom-link ${this.get('isCheckinPath') ? 'active' : ''}`;
  }),

  actions: {
    goToTodaysCheckin() {
      this.routeToCheckin(moment(new Date()).format("YYYY-MM-DD"));
    },
  },
});
