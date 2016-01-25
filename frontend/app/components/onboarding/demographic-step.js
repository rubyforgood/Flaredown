import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      Ember.Logger.debug('demographic-step: completeStep');
      this.sendAction('onStepCompleted');
    },

    goBack() {
      Ember.Logger.debug('demographic-step: goBack');
      this.sendAction('onGoBack');
    }
  }

});
