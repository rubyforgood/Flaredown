import Ember from 'ember';
import UnauthenticatedRouteMixin from 'flaredown/mixins/unauthenticated-route-mixin';

const {
  get,
  RSVP: { resolve },
} = Ember;

export default Ember.Route.extend(UnauthenticatedRouteMixin, {
  model(params) {
    return get(this, 'store').findRecord('password', params.password_id).catch(() => {
      resolve(false);
    });
  }
});
