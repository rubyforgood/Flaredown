import Ember from 'ember';

export default Ember.Component.extend({

  model: Ember.computed.alias('parentView.model'),

  actions: {
    completeStep() {
      var profile = this.get('model.profile');
      profile.save().then( () => {
        this.get('onStepCompleted')();
      });
    }
  }

});
