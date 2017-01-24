import Ember from 'ember';

const {
  get,
  set,
  computed,
  Component,
  computed: { alias },
} = Ember;

export default Component.extend({
  chartsVisibility: alias('chartsVisibilityService.payload'),

  didReceiveAttrs() {
    this._super(...arguments);

    set(this, 'selectedCategory', get(this, 'categories.firstObject'));
  },

  categories: computed('chartsVisibility', function() {
    const chartsVisibility = get(this, 'chartsVisibility');

    return Object.keys(chartsVisibility).filter(chart => chartsVisibility[chart].length);
  }),

  charts: computed('selectedCategory', function() {
    return get(this, `chartsVisibility.${get(this, 'selectedCategory')}`);
  }),
});
