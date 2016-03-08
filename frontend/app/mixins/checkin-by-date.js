import Ember from 'ember';

/*
  Assumes the following exist:
    this.get('store')
    this.router
*/

export default Ember.Mixin.create({

  routeToCheckin: function(date, step) {
    this.get('store').query('checkin', {date: date}).then(results => {
      var records = results.toArray();
      if (Ember.isEmpty(records)) {
        var newCheckin = this.get('store').createRecord('checkin', {date: date});
        newCheckin.save().then(savedCheckin => {
          this.router.transitionTo('checkin', savedCheckin.get('id'), step ? step : 'start');
        });
      } else {
        let checkin = records[0];
        this.router.transitionTo('checkin', checkin.get('id'), step ? step : 'summary');
      }
    });
  }

});
