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
        console.log(records)
        if (Ember.isEmpty(records)) {
          reject();
        } else {
          resolve(records);
        }
      });
    });
  },

  routeToTodaysCheckin(date, step) {
    this.checkinByDate(date).then( checkin => {
      let defaultStep = checkin[0].get('isBlank') ? 'start' : 'summary';
      if (typeof FastBoot === 'undefined') {
        this.router.transitionTo('checkin.show', checkin[0].get('id'), step ? step : defaultStep); // probably want to change this [0] business
      }
    });
  },

  routeToTodaysCheckins(date, step) {
    this.checkinByDate(date).then( checkins => {
      if (typeof FastBoot === 'undefined') {
        console.log('here');
        this.router.transitionTo('checkin.date', date);
      }
    });
  },

  routeToNewCheckin(date, step) {
    console.log("creating new...")
    var newCheckin = this.get('store').createRecord('checkin', {date: date});
    newCheckin.save().then(savedCheckin => {
      this.router.transitionTo('checkin.show', savedCheckin.get('id'), step ? step : 'start');
    });
  },

  routeToCheckin(checkin, step) {
    this.router.transitionTo("checkin.show", checkin.id, step ? step : "start")
  },

  actions: {
    goToTodaysCheckin() {
      this.routeToTodaysCheckin(moment(new Date()).format("YYYY-MM-DD"));
    },
    goToTodaysCheckins() {
      console.log("actions");
      this.routeToTodaysCheckins(moment(new Date()).format("YYYY-MM-DD"));
    },
    goToNewCheckin() {
      // add specific date here
      this.routeToNewCheckin(moment(new Date()).format("YYYY-MM-DD"));
    },
    goToCheckin(checkin) {
      this.routeToCheckin(checkin)
    },
  },
});
