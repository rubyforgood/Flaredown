import DS from 'ember-data';

export default DS.Model.extend({
  email: DS.attr('string'),
  resetPasswordToken: DS.attr('string'),
  password: DS.attr('string'),
  passwordConfirmation:  DS.attr('string')
});
