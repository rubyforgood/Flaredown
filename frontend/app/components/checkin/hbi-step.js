import Ember from 'ember';

const {
  Component,
  computed: { alias },
} = Ember;

export default Component.extend({
  step: alias('model.currentStep'),
  model: alias('parentView.model'),

  actions: {
    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
    },
  },
});
