import Ember from 'ember';
import StepControl from 'flaredown/mixins/step-control';

const {
  computed: {
    alias,
    equal,
  },
} = Ember;

export default Ember.Component.extend(StepControl, {
  classNames: ['flaredown-white-box'],
  isOnboarding: true,
  routeAfterCompleted: 'index',

  step: alias('model.currentStep'),
  stepName: alias('step.stepName'),

  isPersonal: equal('stepName', 'personal'),
  isSymptoms: equal('stepName', 'symptoms'),
  isCompleted: equal('stepName', 'completed'),
  isConditions: equal('stepName', 'conditions'),
  isTreatments: equal('stepName', 'treatments'),
  isDemographic: equal('stepName', 'demographic'),
});
