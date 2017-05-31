import attr from 'ember-data/attr';
import Model from 'ember-data/model';

export default Model.extend({
  kind: attr('string'),
  count: attr('number'),
  postId: attr('string'),
  postTitle: attr('string'),
  unread: attr('boolean'),
  notificateableId: attr('string'),
  notificateableType: attr('string')
});
