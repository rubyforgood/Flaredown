/* global moment */
import Ember from 'ember';
import StepControl from 'flaredown/mixins/step-control';

export default Ember.Component.extend(StepControl, {

  classNames: ['process-step-container'],

  step: Ember.computed.alias('model.currentStep'),
  isStart: Ember.computed.equal('step.key', 'start'),
  isConditions: Ember.computed.equal('step.key', 'conditions'),
  isSymptoms: Ember.computed.equal('step.key', 'symptoms'),
  isTreatments: Ember.computed.equal('step.key', 'treatments'),
  isTags: Ember.computed.equal('step.key', 'tags'),
  isSummary: Ember.computed.equal('step.key', 'summary'),

  checkin: Ember.computed.alias('model.checkin'),

  // Needed by StepControlMixin
  stepKey: 'model.currentStep',
  routeAfterCompleted: 'index'

});
