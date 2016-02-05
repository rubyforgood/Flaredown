import Ember from 'ember';

export default Ember.Mixin.create({

  strokeClass: Ember.computed('colorId', function() {
    return `colorable-stroke-${this.get('colorId')}`;
  }),
  bgClass: Ember.computed('colorId', function() {
    return `colorable-bg-${this.get('colorId')}`;
  })

});
