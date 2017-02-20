import Ember from 'ember';

const {
  get,
  set,
  Mixin,
  computed,
} = Ember;

export default Mixin.create({
  step: computed('model.stepId', 'stepsService.currentTrackables.[]', function() {
    return get(this, `stepsService.steps.${get(this, 'model.stepId')}`);
  }),

  actions: {
    moveToNextStep() {
      const step = get(this, 'step');

      if (!get(step, 'nextId')) {
        this.router.transitionTo(this.routeAfterCompleted);
      } else {
        const nextStep = get(this, `stepsService.steps.${step.nextId}`);

        if (get(this, 'isOnboarding')) {
          let profile = get(this, 'model.profile');
          const savedStepId = get(profile, 'onboardingStepId');

          if (nextStep.prevId === savedStepId) {
            set(profile, 'onboardingStep', nextStep);

            profile.save().then(() => this.transitionTo(nextStep));
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
