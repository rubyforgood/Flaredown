import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  Route,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
});
