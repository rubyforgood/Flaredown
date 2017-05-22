import Ember from 'ember';
import UnauthenticatedRouteMixin from 'flaredown/mixins/unauthenticated-route-mixin';

const {
  $,
  Route,
} = Ember;

export default Route.extend(UnauthenticatedRouteMixin, {
  afterModel() {
    $('.unauthenticated').removeClass('hideTag');
  },
});
