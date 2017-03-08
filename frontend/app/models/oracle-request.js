import DS from 'ember-data';
import Ember from 'ember';

const {
  attr,
  Model,
  belongsTo,
} = DS;

const {
  computed,
  getProperties,
  computed: {
    alias,
  }
} = Ember;

export default Model.extend({
  age: attr('number'),
  symptomIds: attr(),

  sex: belongsTo('sex'),
  country: belongsTo('country'),

  sexId: alias('sex.id'),
  countryId: alias('country.id'),

  notReady: computed('age', 'sexId', 'countryId', 'symptomIds', function() {
    const { age, sexId, countryId, symptomIds } = getProperties(this, 'age', 'sexId', 'countryId', 'symptomIds');

    return !age || !sexId || !countryId || !symptomIds || !symptomIds.length;
  }),
});
