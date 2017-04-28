import attr from 'ember-data/attr';
import Model from 'ember-data/model';

export default Model.extend({
  kind: attr('string'),
  count: attr('number'),
  notificateableId: attr('string'),
  notificateableType: attr('string'),
  notificateableParentId: attr('string'),
});
