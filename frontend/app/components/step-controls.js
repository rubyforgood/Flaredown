import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['step-controls'],

  backLabel: 'Back',
  forwardLabel: 'Continue',
  showBack: true,

  actions: {
    forward() {
      this.get('onForward')();
    },
    backward() {
      this.get('onBackward')();
    }
  }

});
