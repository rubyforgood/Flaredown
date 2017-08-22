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
  airbrake: service(),
  session: service(),

  beforeModel() {
    get(this, 'notifications').loadNotifications();
  },

  sessionAuthenticated() {
    this._super(...arguments);

    get(this, 'airbrake').setSession({ data: get(this, 'session.data.authenticated') });
    get(this, 'notifications').loadNotifications();
  },

  sessionInvalidated() {
    this._super(...arguments);

    get(this, 'airbrake').setSession({ message: 'Unauthorized user' });
  },

  actions: {
    routeToLogin() {
      this.router.transitionTo('login');
    },
  },
});
