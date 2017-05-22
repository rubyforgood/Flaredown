import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';

const {
  set,
  get,
  Route,
  RSVP: {
    hash,
  },
} = Ember;

export default Route.extend(HistoryTrackable, {
  queryParams: {
    following: { refreshModel: true },
    query: { refreshModel: true }
  },

  currentUser: get(this, 'session.currentUser'),

  model(params) {
    set(this, 'query', params.query);
    const currentUser = get(this, 'currentUser');

    return hash({
      posts: get(this, 'store').query('post', params).then(q => q.toArray()),
      topicFollowing: currentUser ? currentUser.then(user => get(user, 'topicFollowing')) : [],
    });
  },
});
