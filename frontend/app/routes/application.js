import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

const {
  get,
  Route,
  inject: {
    service,
  },
} = Ember;

export default Route.extend(ApplicationRouteMixin, {
  notifications: service(),
  session: service(),

  beforeModel() {
    get(this, 'notifications').loadNotifications();
  },

  sessionAuthenticated() {
    this._super(...arguments);

    get(this, 'notifications').loadNotifications();
  },

  actions: {
    routeToLogin() {
      this.router.transitionTo('login');
    },
  },
});
