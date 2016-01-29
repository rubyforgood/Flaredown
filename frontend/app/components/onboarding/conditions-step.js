import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),

  selectableData: Ember.inject.service(),
  tracking: Ember.inject.service(),

  setupTracking: Ember.on('init', function() {
    this.get('tracking').setAt(new Date());
  }),

  conditions: Ember.computed.alias('selectableData.conditions'),
  existingTrackings: Ember.computed.alias('tracking.existingTrackings'),
  newTrackings: Ember.computed.alias('tracking.newTrackings'),

  actions: {
    trackCondition() {
      this.get('tracking').track(this.get('selectedCondition'), () => {
        this.set('selectedCondition', null);
      });
    },

    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
    }
  }

});
