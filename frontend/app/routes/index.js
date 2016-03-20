/* global moment */
import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

export default Ember.Route.extend(CheckinByDate, AuthenticatedRouteMixin, {

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
