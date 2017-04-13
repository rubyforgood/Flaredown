import Ember from 'ember';
import HistoryTrackable from 'flaredown/mixins/history-trackable';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  Route,
} = Ember;

export default Route.extend(HistoryTrackable, AuthenticatedRouteMixin, {
  model() {
    return get(this, 'session.currentUser').then(user => get(user, 'topicFollowing'));
  },
});
