import Ember from 'ember';

const {
  get,
  computed,
  Component,
  computed: {
    not,
    alias,
  },
} = Ember;

export default Component.extend({
  name: alias('item.name'),
  disabled: not('model.canEdit'),
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
