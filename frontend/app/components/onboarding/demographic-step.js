import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      Ember.Logger.debug('demographic-step: completeStep');
      this.get('onStepCompleted')();
    },

    goBack() {
      Ember.Logger.debug('demographic-step: goBack');
      this.get('onGoBack')();
    }
  }

});
