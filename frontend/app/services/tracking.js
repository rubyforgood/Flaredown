import Ember from 'ember';

export default Ember.Service.extend({
  store: Ember.inject.service(),

  setup: function(options) {
    this.setProperties({
      at: options.at,
      trackableType: options.trackableType
    });
    this.set('newTrackings', Ember.A([]));
  },

  existingTrackings: Ember.computed('at', 'trackableType', function() {
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
      if (Ember.isPresent(callback)) {
        callback(savedTracking);
      }
    });
  },

  // params can be either {trackable: aTrackable} or {tracking: aTracking}
  untrack: function(params, callback) {
    var tracking = params.tracking;
    if (Ember.isPresent(tracking)) {
      this.destroyTracking(tracking, callback);
    } else {
      Ember.RSVP.resolve(params.trackable).then(trackable => {
        this.get('existingTrackings').then(trackings => {
          tracking = trackings.find(record => {
            return this.compare(record, trackable);
          });
          if (Ember.isPresent(tracking)) {
            this.destroyTracking(tracking, callback);
          } else {
            tracking = this.get('newTrackings').find(record => {
              return this.compare(record, trackable);
            });
            this.destroyTracking(tracking, callback);
          }
        });
      });
    }
  },

  compare: function(tracking, trackable) {
    return Ember.isEqual(tracking.get('trackable.id'), trackable.get('id')) &&
    Ember.isEqual(tracking.get('trackableType').toLowerCase(), trackable.get('constructor.modelName'));
  },

  destroyTracking: function(tracking, callback) {
    tracking.destroyRecord().then(function() {
      if (Ember.isPresent(callback)) {
        callback();
      }
    });
  }

});
