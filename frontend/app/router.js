import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,

  didTransition() {
    this._super(...arguments);
    this.notifyPageChange();
  },

  notifyPageChange() {
    Ember.run.scheduleOnce('afterRender', this, () => {
      if (Ember.isPresent(window.AndroidInterface)) {
        AndroidInterface.pageChanged(document.location.href);
      }
    });
  }
});

Router.map(function() {
  this.route('login');
  this.route('signup');

  this.route('discourse-sign-in', { path: '/discourse/sign_in' });

  this.route('password', function() {
    this.route('reset');
    this.route('update', { path: ':password_id' });
  });

  this.route('invitation', { path: '/invitation/:invitation_id' });
  this.route('onboarding', { path: '/onboarding/:step_key' });
  this.route('checkin', { path: '/checkin/:checkin_id/:step_key' });

  this.route('terms-of-service');
  this.route('privacy-policy');

});

export default Router;
