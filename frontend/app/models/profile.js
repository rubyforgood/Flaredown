import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  // Attributes
  birthDate: DS.attr('string'),  // keep this as string as we don't need time info
                                 // and HTML5 date input likes yyyy-dd-mm format as returned by APIs

  // Associations
  country: DS.belongsTo('country'),
  sex: DS.belongsTo('sex'),
  onboardingStep: DS.belongsTo('step'),

  // Properties
  isOnboarded: Ember.computed.alias('onboardingStep.isLast')
});
