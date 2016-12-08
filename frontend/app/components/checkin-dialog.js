import Ember from 'ember';
import StepControl from 'flaredown/mixins/step-control';

export default Ember.Component.extend(StepControl, {

  classNameBindings: ['isSummary:checkin-summary:flaredown-white-box'],

  step: Ember.computed.alias('model.currentStep'),
  isStart: Ember.computed.equal('step.key', 'start'),
  isConditions: Ember.computed.equal('step.key', 'conditions'),
  isSymptoms: Ember.computed.equal('step.key', 'symptoms'),
  isTreatments: Ember.computed.equal('step.key', 'treatments'),
  isTags: Ember.computed.equal('step.key', 'tags'),
  isFoods: Ember.computed.equal('step.key', 'foods'),
  isSummary: Ember.computed.equal('step.key', 'summary'),

  checkin: Ember.computed.alias('model.checkin'),

  // Needed by StepControlMixin
  stepKey: 'model.currentStep',
  routeAfterCompleted: 'chart'

});
