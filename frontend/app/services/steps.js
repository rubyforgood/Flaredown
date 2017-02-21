import Ember from 'ember';

const {
  get,
  Service,
  computed,
  getProperties,
} = Ember;

export default Service.extend({
  currentTrackables: [],

  checkinSeed: [
    'start',
    'conditions',
    'symptoms',
    'treatments',
    'health_factors',
    'harvey_bradshaw',
    'summary',
  ],

  onboardingSeed: [
    'personal',
    'demographic',
    'conditions',
    'symptoms',
    'treatments',
    'completed',
  ],

  steps: computed('currentTrackables.[]', function() {
    const { checkinSeed, onboardingSeed } = getProperties(this, 'checkinSeed', 'onboardingSeed');

    return Object.assign(
      {},
      this.generateSteps('checkin', checkinSeed),
      this.generateSteps('onboarding', onboardingSeed)
    );
  }),

  exclusions: computed('currentTrackables.[]', function() {
    let result = {};

    const currentTrackables = get(this, 'currentTrackables');

    if (!currentTrackables.includes("Crohn's disease")) {
      result['harvey_bradshaw'] = true;
    }

    return result;
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

        result[id] = {
          id,
          prevId,
          prefix,
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
