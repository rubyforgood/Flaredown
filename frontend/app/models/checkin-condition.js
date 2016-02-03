import DS from 'ember-data';

export default DS.Model.extend({
  value: DS.attr('number'),
  condition: DS.belongsTo('condition')
});
