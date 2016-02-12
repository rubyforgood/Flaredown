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
      this.get('tracking').track(this.get('selectedTrackable'), null, () => {
        this.set('selectedTrackable', null);
      });
    },
    remove(tracking) {
      this.get('tracking').untrack({
        tracking: tracking
      });
    }
  }

});
