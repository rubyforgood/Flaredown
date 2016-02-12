import Ember from 'ember';
import TrackablesFromTypeMixin from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromTypeMixin, {

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
    trackSelected() {
      var selectedTrackable = this.get('selectedTrackable');
      if (Ember.isPresent(selectedTrackable.get('id'))) {
        this.track(selectedTrackable);
      } else {
        selectedTrackable.save().then( savedTrackable => {
          this.track(savedTrackable);
        });
      }
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
