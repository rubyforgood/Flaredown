import DS from 'ember-data';

export default DS.Model.extend({

  // Attributes
  email: DS.attr('string'),
  password: DS.attr('string'),
  passwordConfirmation: DS.attr('string'),
  screenName: DS.attr('string'),
  captchaResponse: DS.attr('string'),
  acceptPrivacyTerms: DS.attr('boolean'),
  birthDate: DS.attr('birthdate', {
    defaultValue() { return new Date(); }
  }),

  // Associations
  user: DS.belongsTo('user', { async: false })

});
