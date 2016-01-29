import Ember from 'ember';

export default Ember.Service.extend({
  dataStore: Ember.inject.service('store'),

  setAt: function(at) {
    this.set('at', at);
  },

  existingTrackings: Ember.computed('at', function() {
    this.set('newTrackings', Ember.A([]));
    return this.get('dataStore').query('tracking', {at: this.get('at')});
  }),

  track: function(trackable, callback) {
    //save new tracking for trackable and then add it to cache
    //so that user can see it immediately without having to re-query the store
    var tracking = this.get('dataStore').createRecord('tracking', {trackable: trackable});
    tracking.save().then( savedTracking => {
      this.get('newTrackings').pushObject(savedTracking);
      callback(savedTracking);
    });
  }

});
