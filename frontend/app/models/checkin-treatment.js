import DS from 'ember-data';

export default DS.Model.extend({
  value: DS.attr('string'),
  treatment: DS.belongsTo('treatment')
});
