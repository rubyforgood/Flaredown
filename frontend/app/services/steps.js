import Ember from 'ember';

const {
  get,
  Service,
  computed,
  getProperties,
} = Ember;

export default Service.extend({
  checkinSeed: [
    'conditions',
    'symptoms',
    'treatments',
    'health_factors',
    'harvey_bradshaw',
    'promotion_rate',
    'summary',
  ],

  onboardingSeed: [
    'personal',
    'demographic',
    'conditions',
    'symptoms',
    'treatments',
    'reminder',
    'completed',
  ],

  steps: computed('exclusions.{harvey_bradshaw,promotion_rate}', function() {
    const { checkinSeed, onboardingSeed } = getProperties(this, 'checkinSeed', 'onboardingSeed');

    return Object.assign(
      {},
      this.generateSteps('checkin', checkinSeed),
      this.generateSteps('onboarding', onboardingSeed)
    );
  }),

  exclusions: computed('checkin.{shouldShowHbiStep,shouldShowPrStep}', function() {
    let schedulePage = {};

    get(this, 'checkin.shouldShowHbiStep') ? {} : schedulePage.harvey_bradshaw = true;
    get(this, 'checkin.shouldShowPrStep')  ? {} : schedulePage.promotion_rate  = true;

    return schedulePage;
  }),

  generateSteps(prefix, stepNames) {
    let result = {};

    const { i18n, exclusions } = getProperties(this, 'i18n', 'exclusions');

    stepNames
      .filter(stepName => !exclusions[stepName])
      .forEach((stepName, priority, steps) => {
        const id = `${prefix}-${stepName}`;
        const prevId = priority && result[`${prefix}-${steps[priority - 1]}`].id || null;
        const translationPrefix = `step.${prefix}.${stepName}`;
        const prefixChanged = prefix == 'checkin' ? `${prefix}.show` : prefix;

        result[id] = {
          id,
          prevId,
          prefix: prefixChanged,
          stepName,
          priority,
          hint: i18n.t(`${translationPrefix}.hint`),
          title: i18n.t(`${translationPrefix}.title`),
          shortTitle: i18n.t(`${translationPrefix}.shortTitle`),
        };

        if (prevId) {
          result[prevId].nextId = id;
        }
      });

    return result;
  },
});
