import Ember from 'ember';

const {
  get,
  set,
  computed: {
    alias,
  },
  Component,
} = Ember;

export default Component.extend({
  profile: alias('model.profile'),

  actions: {
    goBack() {
      this.get('onGoBack')();
    },

    completeStep() {
      const profile = get(this, 'profile');
      set(profile, 'onboardingReminder', true);

      profile.save().then( () => {
        this.get('onStepCompleted')();
      });
    },
  }
});
