import Ember from 'ember';

const {
  computed: {
    alias,
  },
  Component,
} = Ember;

export default Component.extend({
  actions: {
    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
    }
  }
});
