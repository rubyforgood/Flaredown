import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  // Attributes
  birthDate: DS.attr('string'),  // please keep this as string as we don't need time info
                                 // and HTML5 date input likes yyyy-dd-mm format as returned by APIs
  dayWalkingHours: DS.attr('number'),
  ethnicityIds: DS.attr(),

  // Associations
  country: DS.belongsTo('country'),
  sex: DS.belongsTo('sex'),
  onboardingStep: DS.belongsTo('step'),
  educationLevel: DS.belongsTo('educationLevel'),
  dayHabit: DS.belongsTo('dayHabit'),
  ethnicities: DS.hasMany('ethnicities'),

  // Properties
  isOnboarded: Ember.computed.alias('onboardingStep.isLast'),

  // Functions
  syncEthnicityIds: Ember.observer('ethnicities', function() {
    this.get('ethnicities').then( ethnicities => {
      this.set('ethnicityIds', ethnicities.mapBy('id'));
    });
  })
});
