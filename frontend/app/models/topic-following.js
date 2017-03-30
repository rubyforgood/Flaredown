import DS from 'ember-data';

const {
  attr,
  Model,
} = DS;

export default Model.extend({
  tagIds: attr(),
  foodIds: attr(),
  updatedAt: attr('date'),
  symptomIds: attr(),
  conditionIds: attr(),
  treatmentIds: attr(),
});
