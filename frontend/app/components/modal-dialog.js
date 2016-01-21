import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['modal'],

  action: 'closeModal',

  onDidInsertElement: Ember.on('didInsertElement', function() {
    Ember.$("body").addClass("modal-open");
  }),

  onWillDestroyElement: Ember.on('willDestroyElement', function(){
    Ember.$("body").removeClass("modal-open");
  }),

  actions: {
    close: function(){
      this.sendAction('action');
    }
  }

});
