import DS from 'ember-data';

const {
  attr,
  Model,
} = DS;

export default Model.extend({
  body: attr('string'),
  type: attr('string'),
  userName: attr('string'),
});
