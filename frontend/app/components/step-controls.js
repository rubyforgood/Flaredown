import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['step-controls'],

  actions: {
    forward() {
      this.sendAction('onForward');
    },
    backward() {
      this.sendAction('onBackward');
    }
  }

});
