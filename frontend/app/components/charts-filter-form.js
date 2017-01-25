import Ember from 'ember';

const {
  get,
  set,
  computed,
  observer,
  Component,
  computed: { alias },
} = Ember;

export default Component.extend({
  chartsVisibility: alias('chartsVisibilityService.payload'),

  didReceiveAttrs() {
    this._super(...arguments);

    get(this, 'chartsVisibilityService').refresh();
  },

  initSelectedCategory: observer('categoriesStruct.firstObject', function() {
    set(this, 'selectedCategory', get(this, 'categoriesStruct.firstObject'));
  }),

  categories: computed('chartsVisibility', function() {
    const chartsVisibility = get(this, 'chartsVisibility');

    return Object.keys(chartsVisibility).filter(chart => chartsVisibility[chart].length);
  }),

  categoriesStruct: computed('categories', function() {
    let result = [];

    get(this, 'categories').forEach(category => {
      result.pushObject({
        value: category,
        label: category.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase()),
      });
    });

    return result;
  }),

  charts: computed('selectedCategory', function() {
    return get(this, `chartsVisibility.${get(this, 'selectedCategory.value')}`);
  }),
});
