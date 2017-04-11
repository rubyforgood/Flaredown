import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  Route,
  RSVP: {
    hash,
  },
} = Ember;

export default Route.extend(HistoryTrackable, AuthenticatedRouteMixin, {
  model() {
    return hash({
      posts: get(this, 'store').query('post', {}).then(q => q.toArray()),
      topicFollowing: get(this, 'session.currentUser').then(user => get(user, 'topicFollowing')),
    });
  },
});
