import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';
import ToggleHeaderLogo from 'flaredown/mixins/toggle-header-logo';

const {
  set,
  get,
  Route,
  RSVP: {
    hash,
  },
} = Ember;

export default Route.extend(HistoryTrackable, ToggleHeaderLogo, {
  queryParams: {
    following: { refreshModel: true },
    query: { refreshModel: true }
  },

  model(params) {
    set(this, 'query', params.query);
    const currentUser = get(this, 'session.currentUser');

    return hash({
      posts: get(this, 'store').query('post', params).then(q => q.toArray()),
      topicFollowing: currentUser ? currentUser.then(user => get(user, 'topicFollowing')) : [],
    });
  },
});
