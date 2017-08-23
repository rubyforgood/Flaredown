import Ember from 'ember';

const {
  get,
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
      get(this, 'profile').save().then( () => {
        this.get('onStepCompleted')();
      });
    },
  }
});
