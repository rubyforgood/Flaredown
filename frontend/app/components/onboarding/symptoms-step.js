import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      Ember.Logger.debug('symptoms-step: completeStep');
      this.sendAction('onStepCompleted');
    },

    goBack() {
      Ember.Logger.debug('symptoms-step: goBack');
      this.sendAction('onGoBack');
    }
  }

});
