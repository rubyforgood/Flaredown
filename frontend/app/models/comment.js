import DS from 'ember-data';

const {
  attr,
  Model,
  belongsTo,
} = DS;

export default Model.extend({
  body: attr('string'),
  userName: attr('string'),

  post: belongsTo('post'),
});
