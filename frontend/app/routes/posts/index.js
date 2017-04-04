import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  Route,
  RSVP: {
    hash,
  },
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  model() {
    return hash({
      posts: get(this, 'store').query('post', {}).then(q => q.toArray()),
      topicFollowing: get(this, 'session.currentUser').then(user => get(user, 'topicFollowing')),
    });
  },
});
