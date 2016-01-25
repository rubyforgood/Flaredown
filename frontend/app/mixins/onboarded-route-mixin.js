import Ember from 'ember';

export default Ember.Mixin.create({

  beforeModel(transition) {
    Ember.RSVP.resolve(this.get('session.currentUser')).then(currentUser => {
      currentUser.get('profile').then(profile => {
        profile.get('onboardingStep').then(step => {
          if (profile.get('isOnboarded')) {
            return this._super(...arguments);
          } else {
            transition.abort();
            this.transitionTo("onboarding", step.get('key'));
          }
        });
      });
    });
  }

});
