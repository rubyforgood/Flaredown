import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  set,
  get,
  Route,
  RSVP: {
    hash,
  },
} = Ember;

export default Route.extend(HistoryTrackable, AuthenticatedRouteMixin, {
  queryParams: {
    following: { refreshModel: true },
    query: { refreshModel: true }
  },

  model(params) {
    set(this, 'query', params.query);
    return hash({
      posts: get(this, 'store').query('post', params).then(q => q.toArray()),
      topicFollowing: get(this, 'session.currentUser').then(user => get(user, 'topicFollowing')),
    });
  },
});
