import DS from 'ember-data';

export default DS.Model.extend({

  // Attributes
  startAt: DS.attr('date'),
  endAt: DS.attr('date'),
  trackableType: DS.attr('string'),
  colorId: DS.attr('string'),

  // Associations
  user: DS.belongsTo('user'),
  trackable: DS.belongsTo('trackable', { polymorphic: true }),

});
