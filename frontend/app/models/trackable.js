import DS from 'ember-data';

export default DS.Model.extend({
  colorId: DS.attr('string'),

  strokeClass: Ember.computed('colorId', function() {
    return `colorable-stroke-${this.get('colorId')}`;
  }),

});
