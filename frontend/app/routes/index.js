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
        default route should be start screen of today's check-in
      Else
        default route should be summary screen of today's check-in
  */
  beforeModel(transition) {
    transition.abort();
    if (this.get('session.isAuthenticated')) {
      this.get('session.currentUser').then(currentUser => {
        currentUser.get('profile').then(profile => {
          profile.get('onboardingStep').then(step => {
            if (profile.get('isOnboarded')) {
              var date = moment(new Date()).format('YYYY-MM-DD');
              this.checkinByDate(date).then(
                () => {
                  this.routeToCheckin(date);
                },
                () => {
                  this.routeToNewCheckin(date);
                }
              );
            } else {
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
