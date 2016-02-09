import DS from 'ember-data';
import Ember from 'ember';

export default Ember.Mixin.create({

  colorId: DS.attr('string'),

  strokeClass: Ember.computed('colorId', function() {
    return `colorable-stroke-${this.get('colorId')}`;
  }),
  bgClass: Ember.computed('colorId', function() {
    return `colorable-bg-${this.get('colorId')}`;
  }),
  borderClass: Ember.computed('colorId', function() {
    return `colorable-border-${this.get('colorId')}`;
  }),
  clrClass: Ember.computed('colorId', function() {
    return `colorable-clr-${this.get('colorId')}`;
  })

});
