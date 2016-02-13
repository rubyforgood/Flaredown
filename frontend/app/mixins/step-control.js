import Ember from 'ember';

// Assumes this.router exists

export default Ember.Mixin.create({

  actions: {

    moveToNextStep() {
      var step = this.get(this.stepKey);
      if (step.get('isLast')) {
        this.router.transitionTo(this.routeAfterCompleted);
      } else {
        step.get('next').then(nextStep => {
          if (Ember.isPresent(this.saveToModel)) {
            var saveTo = this.get(this.saveToModel);
            var savedStep = saveTo.get(this.saveToKey);
            if (Ember.isEqual(nextStep.get('prev.id'), savedStep.get('id'))) {
              saveTo.set(this.saveToKey, nextStep);
              saveTo.save().then( () => {
                this.transitionTo(nextStep);
              });
            } else {
              this.transitionTo(nextStep);
            }
          } else {
            this.transitionTo(nextStep);
          }
        });
      }
    },

    moveToPrevStep() {
      var step = this.get(this.stepKey);
      step.get('prev').then(prevStep => {
        this.transitionTo(prevStep);
      });
    }

  },

  transitionTo: function(step) {
    this.router.transitionTo(step.get('group'), step.get('key'));
  }

});
