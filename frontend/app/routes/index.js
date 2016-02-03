import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import OnboardedRouteMixin from 'flaredown/mixins/onboarded-route';

export default Ember.Route.extend(OnboardedRouteMixin, AuthenticatedRouteMixin, {

});
