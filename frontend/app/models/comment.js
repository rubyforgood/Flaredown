import attr from 'ember-data/attr';
import Ember from 'ember';
import Typeable from 'flaredown/mixins/typeable';
import Reactable from 'flaredown/models/reactable';
import BodyFormatable from 'flaredown/mixins/body-formatable';

import { belongsTo } from 'ember-data/relationships';

const {
  computed: {
    or,
  },
} = Ember;

export default Reactable.extend(Typeable, BodyFormatable, {
  body: attr('string'),
  userName: attr('string'),
  createdAt: attr('date'),
  postableId: attr('string'),
  notifications: attr(),

  post: belongsTo('post'),

  hasNotifications: or('notifications.comment', 'notifications.reaction'),
});
