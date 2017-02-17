import Ember from 'ember';

const {
  get,
  Component,
  computed: { alias }
} = Ember;

export default Component.extend({
  step: alias('stepsService.steps.checkin-start'),
  model: alias('parentView.model'),

  actions: {
    completeStep() {
      get(this, 'onStepCompleted')();
    },

    goBack() {
      get(this, 'onGoBack')();
    }
  }
});
