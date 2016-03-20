/* global moment */
import Ember from 'ember';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';
import config from './config/environment';

const Router = Ember.Router.extend(CheckinByDate, {
  location: config.locationType,


  /*
    REQUIREMENTS:
    If the user hasn't completed the onboarding process
      default route is the last completed onboarding step
    Else
      If the user has already checked-in today
        default route when they open the app should be the chart
      Else
        default route should be today's check-in
  */
  beforeModel(transition) {
    if (this.get('session.isAuthenticated')) {
      this.get('session.currentUser').then(currentUser => {
        currentUser.get('profile').then(profile => {
          profile.get('onboardingStep').then(step => {
            if (profile.get('isOnboarded')) {
              var date = moment(new Date()).format('YYYY-MM-DD');
              this.checkinByDate(date).then(
                () => {
                  return this._super(...arguments);
                },
                () => {
                  transition.abort();
                  this.routeToNewCheckin(date);
                }
              );
            } else {
              transition.abort();
              this.transitionTo("onboarding", step.get('key'));
            }
          });
        });
      });
    } else {
      return this._super(...arguments);
    }
  }

});

Router.map(function() {
  this.route('upcoming');
  this.route('login');
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
