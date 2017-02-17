import Ember from 'ember';

const {
  get,
  Mixin,
} = Ember;

export default Mixin.create({
  actions: {
    moveToNextStep() {
      const step = get(this, 'step');

      if (!get(step, 'nextId')) {
        this.router.transitionTo(this.routeAfterCompleted);
      } else {
        const nextStep = get(this, `stepsService.steps.${step.nextId}`);

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
      }
    },

    moveToPrevStep() {
      const step = get(this, 'step');
      const prevStep = get(this, `stepsService.steps.${step.prevId}`);

      this.transitionTo(prevStep);
    }
  },

  transitionTo: function(step) {
    this.router.transitionTo(step.prefix, step.stepName);
  }
});
