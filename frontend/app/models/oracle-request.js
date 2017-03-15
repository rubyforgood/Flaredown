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
  getProperties,
  $: {
    ajax,
  },
  computed: {
    alias,
  },
} = Ember;

export default Model.extend({
  age: attr('number'),

  sex: belongsTo('sex'),

  sexId: alias('sex.id'),

  symptoms: [],

  notReady: computed('age', 'sexId', 'symptomIds', function() {
    const { age, sexId, symptomIds } = getProperties(this, 'age', 'sexId', 'symptomIds');

    return !age || !sexId || !symptomIds.length;
  }),

  symptomIds: computed('symptoms.@each.id', function() {
    return get(this, 'symptoms').mapBy('id');
  }),

  payload: computed('age', 'sexId', 'symptomIds', function() {
    const params = getProperties(this, 'age', 'sex.id', 'symptoms');

    return {
      age: parseInt(params.age),
      sex: params['sex.id'],
      symptoms: params.symptoms.map(s => getProperties(s, 'name')),
    };
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

  askOracle() {
    const data = JSON.stringify(get(this, 'payload'));

    return ajax({
      data,
      url: '//34.207.197.147:5000/main',
      method: 'POST',
      dataType: 'json',
      contentType: 'application/json; charset=UTF-8',
    })
    .then(r => set(this, 'responce', r.sortBy('confidence').reverse()));
  }
});
