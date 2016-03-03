import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['reset-password-form'],

  setupModel: Ember.on('init', function(){
    this.set('model', this.store.createRecord('password'));
  }),

  onWillDestroyElement: Ember.on('willDestroyElement', function(){
    this.discardChanges();
  }),

  discardChanges() {
    var model = this.get('model');
    if( model.get('isNew') ) {
      var statePath = model.get('stateManager.currentPath');
      if (!Ember.isEqual(statePath,'created.inFlight')) {
        model.transitionTo('created.uncommitted');
      }
      model.deleteRecord();
    }
  },

  actions: {
    resetPassword() {
      this.get('model').save().then( () => {
        this.set('model', this.store.createRecord('password'));
        this.set('successfulReset', true);
      });
    }
  }
});
