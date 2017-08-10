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
  fastboot: service(),

  beforeModel() {
    if (!get(this, 'fastboot.isFastBoot')) {
      const shoebox = get(this, 'fastboot.shoebox');
      const shoeboxStore = shoebox.retrieve('CommonStore');
      const store = get(this, 'store');

      if(shoeboxStore) {
        shoeboxStore.payloads.forEach(payload => {
          store.pushPayload(payload);
        });
      }
    }

    get(this, 'notifications').loadNotifications();

    return this._super(...arguments);
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
