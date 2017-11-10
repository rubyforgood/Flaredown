import Ember from 'ember';

/*
  Assumes the following exist:
    this.get('store')
    this.router
*/

export default Ember.Mixin.create({

  checkinByDate(date) {
    return new Ember.RSVP.Promise((resolve,reject) => {
      this.get('store').query('checkin', {date: date}).then(results => {
        var records = results.toArray();
        if (Ember.isEmpty(records)) {
          reject();
        } else {
          resolve(records[0]);
        }
      });
    });
  },

  routeToCheckin(date, step) {
    this.checkinByDate(date).then( checkin => {
      let defaultStep = checkin.get('isBlank') ? 'start' : 'summary';
      if (typeof FastBoot === 'undefined') {
        this.router.transitionTo('checkin.show', checkin.get('id'), step ? step : defaultStep);
      }
    }, () => {
      this.routeToNewCheckin(date, step);
    });
  },

  routeToNewCheckin(date, step) {
    var newCheckin = this.get('store').createRecord('checkin', {date: date});
    newCheckin.save().then(savedCheckin => {
      this.router.transitionTo('checkin.show', savedCheckin.get('id'), step ? step : 'start');
    });
  },

  actions: {
    goToTodaysCheckin() {
      this.routeToCheckin(moment(new Date()).format("YYYY-MM-DD"));
    },
  },
});
