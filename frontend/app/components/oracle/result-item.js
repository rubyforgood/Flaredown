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

  confidence: computed('item.confidence', function() {
    return Math.round(get(this, 'item.confidence') * 100) / 100;
  }),
});
