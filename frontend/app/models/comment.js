import DS from 'ember-data';
import BodyFormatable from 'flaredown/mixins/body-formatable';

const {
  attr,
  Model,
  belongsTo,
} = DS;

export default Model.extend(BodyFormatable, {
  body: attr('string'),
  userName: attr('string'),
  createdAt: attr('date'),
  postableId: attr('string'),

  post: belongsTo('post'),
});
