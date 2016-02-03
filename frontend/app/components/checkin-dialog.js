import Ember from 'ember';
import StepControlMixin from 'flaredown/mixins/step-control-mixin';

export default Ember.Component.extend(StepControlMixin, {

  classNames: ['checkin'],

  step: Ember.computed.alias('model.currentStep'),

  isStart: Ember.computed.equal('step.key', 'start'),
  isConditions: Ember.computed.equal('step.key', 'conditions'),
  isSymptoms: Ember.computed.equal('step.key', 'symptoms'),
  isTreatments: Ember.computed.equal('step.key', 'treatments'),
  isTags: Ember.computed.equal('step.key', 'tags'),
  isSummary: Ember.computed.equal('step.key', 'summary'),

  // Needed by StepControlMixin
  stepKey: 'model.currentStep',
  routeAfterCompleted: 'index'

});
