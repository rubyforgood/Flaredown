import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  RSVP,
  Route,
  getProperties,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  model(params) {
    return get(this, 'session.currentUser').then(currentUser => {
      const stepId = `${this.routeName}-${params.step_key}`;

      return RSVP.hash({
        stepId,
        profile: get(currentUser, 'profile'),
      });
    });
  },

  afterModel(model, transition) {
    get(this, 'session.currentUser.profile').then(profile => {
      const savedStep = get(profile, 'onboardingStep');
      const currentStep = get(this, `stepsService.steps.${model.stepId}`);

      if (currentStep.priority > savedStep.priority) {
        transition.abort();

        const { prefix, stepName } = getProperties(savedStep, 'prefix', 'stepName');

        this.transitionTo(prefix, stepName);
      }
    });
  },
});
