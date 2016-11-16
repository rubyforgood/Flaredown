import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),
  profile: Ember.computed.alias('model.profile'),

  educationLevels: Ember.computed(function() {
    return this.store.findAll('educationLevel');
  }),

  actions: {
    completeStep() {
      this.get('profile').save().then( () => {
        this.get('onStepCompleted')();
      });
    },

    goBack() {
      this.get('onGoBack')();
    }
  }

});
