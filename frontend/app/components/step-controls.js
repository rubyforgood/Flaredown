import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['step-controls'],

  backLabel: 'Back',
  forwardLabel: 'Continue',
  showBack: true,

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
    }
  }

});
