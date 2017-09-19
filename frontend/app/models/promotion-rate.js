import DS from 'ember-data';

const {
  attr,
  Model,
  belongsTo,
} = DS;

export default Model.extend({
  score: attr('number'),
  feedback: attr('string'),
  checkin: belongsTo('checkin'),
});
