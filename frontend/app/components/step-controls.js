import Ember from 'ember';

const {
  Component,
  computed: { bool },
} = Ember;

export default Component.extend({
  classNames: ['step-controls'],

  showBack: true,
  backLabel: 'Back',
  forwardLabel: 'Continue',

  stepHasPrev: bool('step.prevId'),

  actions: {
    forward() {
      if (!this.get('disabled')) {
        this.get('onForward')();
      }
    },

    backward() {
      if (!this.get('disabled')) {
        this.get('onBackward')();
      }
    },
  },
});
