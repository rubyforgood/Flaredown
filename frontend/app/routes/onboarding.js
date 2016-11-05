import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {

  model(params) {
    return this.get('session.currentUser').then(currentUser => {
      var stepId = `${this.routeName}-${params.step_key}`;
      return Ember.RSVP.hash({
        profile: currentUser.get('profile'),
        currentStep: this.store.find('step', stepId)
      });
    });
  },

  afterModel(model, transition) {
    this.get('session.currentUser.profile.onboardingStep').then(savedStep => {
      if (model.currentStep.get('priority') > savedStep.get('priority')) {
        transition.abort();
        this.transitionTo(savedStep.get('group'), savedStep.get('key'));
      }
    });
  }

});
