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
  model(params) {
    const { id, type } = params;
    const store = get(this, 'store');

    return hash({
      posts: store.query('post', { id, type }),
      topic: store.findRecord(type, id),
    });
  },
});
