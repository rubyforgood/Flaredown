import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  Route,
  RSVP: {
    hash,
  },
} = Ember;

const availableTypes = ['tag', 'symptom', 'condition', 'treatment'];

export default Route.extend(AuthenticatedRouteMixin, {
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
});
