import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import OnboardedRoute from 'flaredown/mixins/onboarded-route';

export default Ember.Route.extend(OnboardedRoute, AuthenticatedRouteMixin, {

});
