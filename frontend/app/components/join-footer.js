import Ember from 'ember';

const {
  get,
  inject: {
    service,
  },
  Component,
} = Ember;

export default Component.extend({
  tagName: ['div'],
  classNames: ['flex-container', 'footer', 'join-footer'],

  _routing: service('-routing'),

  click() {
    get(this, '_routing').transitionTo('signup');
  },
});
