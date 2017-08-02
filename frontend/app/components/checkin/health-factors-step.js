import Ember from 'ember';

const {
  Component,
  computed: { alias },
  inject: { service },
} = Ember;

export default Component.extend({
  store: service(),
  model: alias('parentView.model'),
  checkin: alias('model.checkin'),

  findFactors(factorClassName, name) {
    const factors = this.get('store').peekAll(factorClassName);
    const existingFactor = factors.findBy('name', name);

    if (existingFactor) {
      this.get('store').unloadRecord(existingFactor);
    }
  },

  actions: {
    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
    },

    onBeforeAddTag(name) {
      this.findFactors('tag', name);
    },

    onBeforeAddFood(name) {
      this.findFactors('food', name);
    },
  },
});
