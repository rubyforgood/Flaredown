import DS from 'ember-data';
import Ember from 'ember';

const {
  attr,
  Model,
  hasMany,
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
  responce: attr(),
  symptomIds: attr(),

  sex: belongsTo('sex'),
  symptoms: hasMany('symptom', { async: false }),

  sexId: alias('sex.id'),

  apiUrl: '//34.207.197.147:5000/main',

  notReady: computed('age', 'sexId', 'symptomIds.[]', function() {
    const { age, sexId, symptomIds } = getProperties(this, 'age', 'sexId', 'symptomIds');

    return !age || !sexId || !symptomIds.length;
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
    get(this, 'symptoms').pushObject(symptom);
    get(this, 'symptomIds').pushObject(parseInt(get(symptom, 'id')));
  },

  removeSymptom(symptom) {
    get(this, 'symptoms').removeObject(symptom);
    get(this, 'symptomIds').removeObject(parseInt(get(symptom, 'id')));
  },

  askOracle() {
    const data = JSON.stringify(get(this, 'payload'));

    return ajax({
      data,
      url: get(this, 'apiUrl'),
      method: 'POST',
      dataType: 'json',
      contentType: 'application/json; charset=UTF-8',
    })
    .then(r => set(this, 'responce', r.sortBy('confidence').reverse()));
  }
});
