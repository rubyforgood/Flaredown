import DS from 'ember-data';
import Ember from 'ember';

const {
  attr,
  Model,
  belongsTo,
} = DS;

const {
  get,
  set,
  computed,
  observer,
  getProperties,
} = Ember;

const numericKeys = [
  'stools',
  'wellBeing',
  'abdominalMass',
  'abdominalPain',
];

const booleanKeys = [
  'abscess',
  'uveitis',
  'arthralgia',
  'newFistula',
  'analFissure',
  'aphthousUlcers',
  'erythemaNodosum',
  'pyodermaGangrenosum',
];

const propKeys = [
  ...booleanKeys,
  ...numericKeys,
];

export default Model.extend({
  stools: attr('number'),
  wellBeing: attr('number'),
  abdominalMass: attr('number'),
  abdominalPain: attr('number'),

  abscess: attr('boolean', { defaultValue: false }),
  uveitis: attr('boolean', { defaultValue: false }),
  arthralgia: attr('boolean', { defaultValue: false }),
  newFistula: attr('boolean', { defaultValue: false }),
  analFissure: attr('boolean', { defaultValue: false }),
  aphthousUlcers: attr('boolean', { defaultValue: false }),
  erythemaNodosum: attr('boolean', { defaultValue: false }),
  pyodermaGangrenosum: attr('boolean', { defaultValue: false }),

  checkin: belongsTo('checkin'),

  wellBeingOptions: [
    { value: 0, label: 'Very well' },
    { value: 1, label: 'Slightly below par' },
    { value: 2, label: 'Poor' },
    { value: 3, label: 'Very poor' },
    { value: 4, label: 'Terrible' },
  ],

  abdominalMassOptions: [
    { value: 0, label: 'None' },
    { value: 1, label: 'Dubious' },
    { value: 2, label: 'Definite' },
    { value: 3, label: 'Definite and tender' },
  ],

  abdominalPainOptions: [
    { value: 0, label: 'None' },
    { value: 1, label: 'Mild' },
    { value: 2, label: 'Moderate' },
    { value: 3, label: 'Severe' },
  ],

  stoolsStringObserver: observer('stoolsString', function() {
    const value = get(this, 'stoolsString');

    set(this, 'stools', typeof value === 'string' && /\d+/.test(value) ? parseInt(value) : 0);
  }),

  notReady: computed(...numericKeys, function() {
    const numeric = getProperties(...numericKeys);

    return numericKeys.any(key => {
      let value = get(this, key);

      return typeof value !== 'number';
    });
  }),

  selectedWellBeing: computed('wellBeing', function() {
    const { wellBeing, wellBeingOptions } = getProperties(this, 'wellBeing', 'wellBeingOptions');

    return wellBeingOptions[wellBeing];
  }),

  selectedAbdominalMass: computed('abdominalMass', function() {
    const { abdominalMass, abdominalMassOptions } = getProperties(this, 'abdominalMass', 'abdominalMassOptions');

    return abdominalMassOptions[abdominalMass];
  }),

  selectedAbdominalPain: computed('abdominalPain', function() {
    const { abdominalPain, abdominalPainOptions } = getProperties(this, 'abdominalPain', 'abdominalPainOptions');

    return abdominalPainOptions[abdominalPain];
  }),

  score: computed(...propKeys, function() {
    const props = getProperties(this, ...propKeys);

    let result = 0;

    propKeys.forEach(key => {
      let value = props[key];

      if (Number.isInteger(value)) {
        result += value;
      } else if (value) {
        result++;
      }
    });

    return result;
  }),
});
