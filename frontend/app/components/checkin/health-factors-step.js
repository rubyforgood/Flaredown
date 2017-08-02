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

  actions: {
    completeStep() {
      this.get('onStepCompleted')();
    },

    goBack() {
      this.get('onGoBack')();
    },

    onBeforeAddTag(name) {
      const tags = this.get('store').peekAll('tag');
      const existingTag = tags.findBy('name', name);

      if (existingTag) {
        this.get('store').unloadRecord(existingTag);
      }
    },

    onBeforeAddFood(name) {
      const foods = this.get('store').peekAll('food');
      const existingFood = foods.findBy('name', name);

      if (existingFood) {
        this.get('store').unloadRecord(existingFood);
      }
    },
  },
});
