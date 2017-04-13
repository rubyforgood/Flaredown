import Ember from 'ember';
import DS from 'ember-data';

const {
  set,
  get,
  computed,
  computed: { not },
} = Ember;

export default DS.Model.extend({
  // Attributes
  screenName: DS.attr('string'),
  birthDate: DS.attr('string'),  // please keep this as string as we don't need time info
                                 // and HTML5 date input likes yyyy-dd-mm format as returned by APIs
  dayWalkingHours: DS.attr('number'),
  ethnicityIds: DS.attr(),
  pressureUnits: DS.attr('string'),
  onboardingStepId: DS.attr('string'),
  temperatureUnits: DS.attr('string'),
  betaTester: DS.attr('boolean'),

  // Associations
  country: DS.belongsTo('country'),
  sex: DS.belongsTo('sex'),
  educationLevel: DS.belongsTo('educationLevel'),
  dayHabit: DS.belongsTo('dayHabit'),
  ethnicities: DS.hasMany('ethnicities'),

  onboardingStep: computed('onboardingStepId', {
    get() {
      let stepId = get(this, 'onboardingStepId') || 'onboarding-personal';

      return get(this, `stepsService.steps.${stepId}`);
    },

    set(_, step) {
      set(this, 'onboardingStepId', step.id);

      return step.id;
    },
  }),

  // Properties
  isOnboarded: not('onboardingStep.nextId'),

  // Functions
  syncEthnicityIds: Ember.observer('ethnicities', function() {
    this.get('ethnicities').then( ethnicities => {
      this.set('ethnicityIds', ethnicities.mapBy('id'));
    });
  })
});
