import DS from 'ember-data';

export default DS.Model.extend({
  //Attributes
  birthDate: DS.attr('date'),

  //Associations
  country: DS.belongsTo('country'),
  sex: DS.belongsTo('sex')
});
