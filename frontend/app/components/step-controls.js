import Ember from 'ember';

const {
  get,
  inject: {
    service,
  },
  Component,
  computed: { bool },
} = Ember;

export default Component.extend({
  classNames: ['step-controls'],

  showBack: true,
  linkForward: false,
  backLabel: 'Back',
  forwardLabel: 'Continue',

  _routing:      service('-routing'),

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

    discussion() {
      get(this, '_routing').transitionTo('posts');
    },
  },
});
