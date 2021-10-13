import Ember from 'ember';

export default Ember.Component.extend({
  model: Ember.computed.alias('parentView.model'),
  profile: Ember.computed.alias('model.profile'),

  educationLevels: Ember.computed(function() {
    return this.store.findAll('educationLevel');
  }),

  ethnicities: Ember.computed(function() {
    return this.store.findAll('ethnicity');
  }),

  dayHabits: Ember.computed(function() {
    return this.store.findAll('dayHabit');
  }),

  actions: {
    validateNumber(event) {
      const inputVar = document.getElementById("input-num");

      if(event.target.value > 24 || event.target.value < 0) {
        alert("Must be a number between 0 - 24");
        inputVar.value = "";
        
        return;
      }
      inputVar.disabled = false;
    },
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
