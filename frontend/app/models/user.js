import DS from 'ember-data';

export default DS.Model.extend({
  //Attributes
  email: DS.attr('string'),
  username: DS.attr('string'),
});
