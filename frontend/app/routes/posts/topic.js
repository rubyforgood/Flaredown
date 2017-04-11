import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  Route,
  getProperties,
  RSVP: {
    hash,
  },
} = Ember;

const availableTypes = ['tag', 'symptom', 'condition', 'treatment'];

export default Route.extend(HistoryTrackable, AuthenticatedRouteMixin, {
  model(params) {
    const { id, type } = params;

    if (!availableTypes.includes(type)) {
      return this.transitionTo('posts');
    }

    const store = get(this, 'store');

    return hash({
      id,
      type,
      page: 1,
      posts: store.query('post', { id, type }).then(q => q.toArray()),
      topic: store.findRecord(type, id),
      topicFollowing: get(this, 'session.currentUser').then(user => get(user, 'topicFollowing')),
    });
  },

  historyEntry(model) {
    const { id, type } = getProperties(model, 'id', 'type');

    return this._super(...arguments).pushObjects([type, id]);
  },
});
