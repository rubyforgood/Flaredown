import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  Route,
  get
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  model() {
    return get(this, 'session.currentUser').then(user => user.get('profile'));
  },

  actions: {
    invalidateSession() {
      this.get('session').invalidate();
    },
  },
});
