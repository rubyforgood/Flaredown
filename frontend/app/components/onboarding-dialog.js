import Ember from 'ember';
import StepControlMixin from 'flaredown/mixins/step-control';

export default Ember.Component.extend(StepControlMixin, {

  classNames: ['process-step-container'],

  step: Ember.computed.alias('model.currentStep'),

  isPersonal: Ember.computed.equal('step.key', 'personal'),
  isDemographic: Ember.computed.equal('step.key', 'demographic'),
  isConditions: Ember.computed.equal('step.key', 'conditions'),
  isSymptoms: Ember.computed.equal('step.key', 'symptoms'),
  isTreatments: Ember.computed.equal('step.key', 'treatments'),
  isCompleted: Ember.computed.equal('step.key', 'completed'),

  // Needed by StepControlMixin
  stepKey: 'model.currentStep',
  saveToModel: 'model.profile',
  saveToKey: 'onboardingStep',
  routeAfterCompleted: 'index'

});
