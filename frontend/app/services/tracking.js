import Ember from 'ember';

export default Ember.Service.extend({
  store: Ember.inject.service(),

  setup: function(options) {
    this.setProperties({
      at: options.at,
      trackableType: options.trackableType
    });
  },

  existingTrackings: Ember.computed('at', function() {
    this.set('newTrackings', Ember.A([]));
    return this.get('store').query('tracking', {
      at: this.get('at'), trackable_type: this.get('trackableType')
    });
  }),

  track: function(trackable, colorId, callback) {
    //save new tracking for trackable and then add it to cache
    //so that user can see it immediately without having to re-query the store
    var tracking = this.get('store').createRecord('tracking', {trackable: trackable, colorId: colorId});
    tracking.save().then( savedTracking => {
      this.get('newTrackings').pushObject(savedTracking);
      callback(savedTracking);
    });
  },

  // params can be either {trackable: aTrackable} or {tracking: aTracking}
  untrack: function(params, callback) {
    var tracking = params.tracking;
    if (Ember.isPresent(tracking)) {
      tracking.destroyRecord().then(function() {
        if (Ember.isPresent(callback)) {
          callback();
        }
      });
    } else {
      var trackable = params.trackable;
      this.get('existingTrackings').then(function(trackings) {
        tracking = trackings.find(function(record) {
          return Ember.isEqual(record.get('trackable.id'), trackable.get('id')) &&
                 Ember.isEqual(record.get('trackableType'), trackable.get('constructor.modelName'));
        });
        tracking.destroyRecord().then(function() {
          callback();
        });
      });
    }
  }

});
