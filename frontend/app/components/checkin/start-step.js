import Ember from 'ember';

export default Ember.Component.extend({

  didReceiveAttrs() {
    this._super(...arguments);
    this.set('step', this.store.findRecord('step', 'checkin-start'));
  },

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
    }
  }

});
