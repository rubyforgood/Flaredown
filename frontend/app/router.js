import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('login');
  this.route('invitation', { path: '/invitation/:invitation_id' });
  this.route('onboarding', { path: '/onboarding/:step_key' });
  this.route('checkin', { path: '/checkin/:checkin_id/:step_key' });
});

export default Router;
