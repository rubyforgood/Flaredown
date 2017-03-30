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
    const page = 1;

    return hash({
      page,
      postables: get(this, 'store').query('postable', { page }),
    });
  },
});
