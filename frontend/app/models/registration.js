import DS from 'ember-data';

export default DS.Model.extend({

  // Attributes
  email: DS.attr('string'),
  password: DS.attr('string'),
  passwordConfirmation: DS.attr('string'),
  screenName: DS.attr('string'),
  captchaResponse: DS.attr('string'),

  // Associations
  user: DS.belongsTo('user', { async: false })

});
