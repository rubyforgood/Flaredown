import DS from 'ember-data';

export default DS.Model.extend({
  user: DS.belongsTo('user', { async: false }),
  email: DS.attr('string'),
  password: DS.attr('string'),
  passwordConfirmation:  DS.attr('string')
});
