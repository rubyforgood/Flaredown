import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      Ember.Logger.debug('personal-step: completeStep');
      this.get('onStepCompleted')();
    }
  }

});
