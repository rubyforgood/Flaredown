import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  set,
  setProperties,
  RSVP,
  Route,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  model(params) {
    return get(this, 'store').findAll('pattern');
  },
});
