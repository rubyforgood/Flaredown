import DS from 'ember-data';
import Ember from 'ember';

const {
  attr,
  Model,
  belongsTo,
} = DS;

const {
  get,
  computed,
  getProperties,
  computed: {
    alias,
  },
} = Ember;

export default Model.extend({
  age: attr('number'),

  sex: belongsTo('sex'),
  country: belongsTo('country'),

  sexId: alias('sex.id'),
  countryId: alias('country.id'),

  symptoms: [],

  notReady: computed('age', 'sexId', 'countryId', 'symptomIds', function() {
    const { age, sexId, countryId, symptomIds } = getProperties(this, 'age', 'sexId', 'countryId', 'symptomIds');

    return !age || !sexId || !countryId || !symptomIds.length;
  }),

  symptomIds: computed('symptoms.@each.id', function() {
    return get(this, 'symptoms').mapBy('id');
  }),

  addSymptom(symptom) {
    const symptoms = get(this, 'symptoms');

    if (!symptoms.includes(symptom)) {
      symptoms.pushObject(symptom);
    }
  },

  removeSymptom(symptom) {
    get(this, 'symptoms').removeObject(symptom);
  },
});
