import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  model() {
    return this.get('session.currentUser').then(user => user.get('profile'));
  },

  actions: {
    invalidateSession() {
      this.get('session').invalidate();
    },
  },
});
