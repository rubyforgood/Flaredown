import Ember from 'ember';

/*
  Assumes the following exit:
    this.get('store')
    this.router
*/

export default Ember.Mixin.create({

  routeToCheckin: function(date, step) {
    this.get('store').queryRecord('checkin', {date: date}).then(checkin => {
      if (Ember.isPresent(checkin)) {
        this.router.transitionTo('checkin', checkin.get('id'), step ? step : 'summary');
      } else {
        var newCheckin = this.get('store').createRecord('checkin', {date: new Date(date)});
        newCheckin.save().then(savedCheckin => {
          this.router.transitionTo('checkin', savedCheckin.get('id'), step ? step : 'start');
        });
      }
    });
  }

});
