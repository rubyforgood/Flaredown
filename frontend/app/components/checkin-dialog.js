import Ember from 'ember';
import StepControl from 'flaredown/mixins/step-control';

const {
  computed: {
    alias,
    equal,
  },
} = Ember;

export default Ember.Component.extend(StepControl, {
  classNames: ['checkin-summary'],
  routeAfterCompleted: 'chart',

  step: alias('model.currentStep'),
  checkin: alias('model.checkin'),
  stepName: alias('step.stepName'),

  isStart: equal('stepName', 'start'),
  isSummary: equal('stepName', 'summary'),
  isSymptoms: equal('stepName', 'symptoms'),
  isConditions: equal('stepName', 'conditions'),
  isTreatments: equal('stepName', 'treatments'),
  isHeathFactors: equal('stepName', 'health_factors'),
});
