import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  Route,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  model() {
    return get(this, 'store').findAll('pattern');
  },
});
