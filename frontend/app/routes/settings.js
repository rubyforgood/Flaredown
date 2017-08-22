import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  inject: {
    service
  },
  Route,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  airbrake: service(),

  model() {
    return this.get('session.currentUser').then(user => user.get('profile'));
  },

  actions: {
    invalidateSession() {
      this.get('session').invalidate();
      get(this, 'airbrake').setSession({ message: 'Unauthorized user' });
    },
  },
});
