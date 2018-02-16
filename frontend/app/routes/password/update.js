import Ember from 'ember';
import UnauthenticatedRouteMixin from 'flaredown/mixins/unauthenticated-route-mixin';

const {
  get,
  Route,
} = Ember;

export default Route.extend(UnauthenticatedRouteMixin, {
  model(params) {
    if (typeof FastBoot === 'undefined') {
      return get(this, 'store').findRecord('password', params.password_id).catch(() => null);
    }
  },
});
