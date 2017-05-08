import attr from 'ember-data/attr';
import Typeable from 'flaredown/mixins/typeable';
import Reactable from 'flaredown/models/reactable';
import Topicable from 'flaredown/mixins/topicable';
import BodyFormatable from 'flaredown/mixins/body-formatable';

import { hasMany } from 'ember-data/relationships';

export default Reactable.extend(Typeable, Topicable, BodyFormatable, {
  body: attr('string'),
  type: attr('string'),
  title: attr('string'),
  userName: attr('string'),
  createdAt: attr('date'),
  postableId: attr('string'),
  notifications: attr(),
  commentsCount: attr('number'),

  comments: hasMany('comment', { async: true }),
});
