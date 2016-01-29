import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({

  // Attributes
  startAt: DS.attr('date'),
  endAt: DS.attr('date'),
  trackableType: DS.attr('string'),

  // Associations
  user: DS.belongsTo('user'),
  trackable: DS.belongsTo('trackable', { polymorphic: true }),

  // Properties
  isForCondition: Ember.computed.equal('trackableType', 'Condition'),
  isForSymptom: Ember.computed.equal('trackableType', 'Symptom'),
  isForTreatment: Ember.computed.equal('trackableType', 'Treatment')

});
