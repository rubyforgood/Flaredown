import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      Ember.Logger.debug('completed-step: completeStep');
      this.sendAction('onStepCompleted');
    },

    goBack() {
      Ember.Logger.debug('completed-step: goBack');
      this.sendAction('onGoBack');
    }
  }

});
