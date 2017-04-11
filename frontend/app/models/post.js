import DS from 'ember-data';
import Topicable from 'flaredown/mixins/topicable';
import BodyFormatable from 'flaredown/mixins/body-formatable';

const {
  attr,
  Model,
  hasMany,
} = DS;

export default Model.extend(Topicable, BodyFormatable, {
  body: attr('string'),
  type: attr('string'),
  title: attr('string'),
  userName: attr('string'),
  createdAt: attr('date'),
  postableId: attr('string'),
  commentsCount: attr('number'),

  comments: hasMany('comment', { async: true }),
});
