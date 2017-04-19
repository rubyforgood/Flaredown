import DS from 'ember-data';

const {
  attr,
  Model,
} = DS;

export default Model.extend({
  count: attr('number'),
  participated: attr('boolean'),
  reactable_id: attr('string'),
  reactable_type: attr('string'),
});
