import Ember from 'ember';

/*
  Assumes the following exist:
    this.get('store')
    this.router
*/

export default Ember.Mixin.create({

  checkinByDate(date) {
    return new Ember.RSVP.Promise((resolve) => {
      this.get('store').query('checkin', {date: date}).then(results => {
        var records = results.toArray();
        resolve(records);
      });
    });
  },

  routeToCheckinsForDate(date) {
    this.checkinByDate(date).then(() => {
      if (typeof FastBoot === 'undefined') {
        this.router.transitionTo('checkin.date', date);
      }
    });
  },

  routeToNewCheckin(date, step) {
    var newCheckin = this.get('store').createRecord('checkin', {date: date});
    newCheckin.save().then(savedCheckin => {
      this.router.transitionTo('checkin.show', savedCheckin.get('id'), step ? step : 'conditions');
    });
  },

  routeToCheckin(checkin, step) {
    this.router.transitionTo('checkin.show', checkin.id, step ? step : 'summary')
  },

  actions: {
    goToTodaysCheckins() {
      this.routeToCheckinsForDate(moment(new Date()).format("YYYY-MM-DD"));
    },
    goToNewCheckin(date) {
      this.routeToNewCheckin(moment(date).format("YYYY-MM-DD"));
    },
    goToCheckin(checkin) {
      this.routeToCheckin(checkin)
    },
  },
});
