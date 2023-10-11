import Ember from 'ember';

const {
  get,
  computed,
  Component,
} = Ember;

export default Component.extend({
  tagName: 'span',
  classNames: ['trackableItem'],
  classNameBindings: ['isLine:line:circle', 'colorableClass'],

  isLine: computed('item.type', function() {
    return get(this, 'item.type') == 'line';
  }),

  colorableClass: computed('item.color_id', function() {
    return `colorable-clr-${get(this, 'item.color_id')}`;
  }),
});
