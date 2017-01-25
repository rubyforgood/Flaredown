import Ember from 'ember';

const {
  $,
  on,
  Component,
} = Ember;

export default Component.extend({
  modal: true,
  action: 'closeModal',
  classNameBindings: ['modal', 'customClass'],

  onDidInsertElement: on('didInsertElement', function() {
    $('body').addClass('modal-open');
  }),

  onWillDestroyElement: on('willDestroyElement', function(){
    $('body').removeClass('modal-open');
  }),

  actions: {
    close() {
      this.sendAction('action');
    },

    fadeOut() {
      if (event.target.className === 'modal-fade-screen') {
        this.sendAction('action');
      }
    },
  },
});
