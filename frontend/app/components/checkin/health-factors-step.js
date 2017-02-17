import Ember from 'ember';

const {
  Component,
  computed: { alias },
} = Ember;

export default Component.extend({
  step: alias('stepsService.steps.checkin-health_factors'),
  model: alias('parentView.model'),
  checkin: alias('model.checkin'),

  actions: {
    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
    },
  },
});
