import Ember from 'ember';

export default Ember.Component.extend({
  embeddedInSummary: false,

  model: Ember.computed.alias('parentView.model'),
  checkin: Ember.computed.alias('model.checkin'),

  didReceiveAttrs() {
    this._super(...arguments);
    this.set('step', this.store.findRecord('step', 'checkin-health_factors'));
  },

  actions: {
    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
    },
  },
});
