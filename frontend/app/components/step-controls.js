import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['step-controls'],

  actions: {
    forward() {
      this.get('onForward')();
    },
    backward() {
      this.get('onBackward')();
    }
  }

});
