import Ember from 'ember';

export default Ember.Component.extend({

  store: Ember.inject.service(),

  actions: {
    routeToCheckin(date) {
      this.get('store').queryRecord('checkin', {date: date}).then(checkin => {
        if (Ember.isPresent(checkin)) {
          this.router.transitionTo('checkin', checkin.get('id'), 'summary');
        } else {
          var newCheckin = this.get('store').createRecord('checkin', {date: new Date(date)});
          newCheckin.save().then(savedCheckin => {
            this.router.transitionTo('checkin', savedCheckin.get('id'), 'start');
          });
        }
      });
    }
  }

});
