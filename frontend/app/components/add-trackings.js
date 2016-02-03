import Ember from 'ember';
import TrackablesFromTypeMixin from 'flaredown/mixins/trackables-from-type';

export default Ember.Component.extend(TrackablesFromTypeMixin, {

  tracking: Ember.inject.service(),

  setupTracking: Ember.on('init', function() {
    this.get('tracking').setAt(new Date());
  }),

  existingTrackings: Ember.computed.alias('tracking.existingTrackings'),
  newTrackings: Ember.computed.alias('tracking.newTrackings'),

  actions: {
    trackSelected() {
      this.get('tracking').track(this.get('selectedTrackable'), () => {
        this.set('selectedTrackable', null);
      });
    }
  }

});
