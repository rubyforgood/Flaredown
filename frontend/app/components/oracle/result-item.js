import Ember from 'ember';

const {
  get,
  computed,
  Component,
  computed: {
    alias,
  },
} = Ember;

export default Component.extend({
  name: alias('item.name'),
  correction: alias('item.correction'),

  confidence: computed('item.confidence', function() {
    return Math.round(get(this, 'item.confidence') * 100) / 100;
  }),

  actions: {
    correctionChanged() {
      get(this, 'model').save();
    },
  },
});
