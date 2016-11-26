import Ember from 'ember';
import TrackablesFromType from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromType, {

  tracking: Ember.inject.service(),

  setupTracking: Ember.on('init', function() {
    this.get('tracking').setup({
      at: new Date(),
      trackableType: this.get('trackableType').capitalize()
    });
  }),

  existingTrackings: Ember.computed.alias('tracking.existingTrackings'),
  newTrackings: Ember.computed.alias('tracking.newTrackings'),

  actions: {
    trackSelected(selectedTrackable) {
      this.track(selectedTrackable);
    },
    remove(tracking) {
      this.get('tracking').untrack({
        tracking: tracking
      });
    }
  },

  track: function(trackable) {
    this.get('tracking').track(trackable, null, () => {
      this.set('selectedTrackable', null);
    });
  }

});
