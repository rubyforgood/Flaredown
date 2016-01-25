import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      Ember.Logger.debug('conditions-step: completeStep');
      this.sendAction('onStepCompleted');
    },

    goBack() {
      Ember.Logger.debug('conditions-step: goBack');
      this.sendAction('onGoBack');
    }
  }

});
