import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';
import moment from 'moment';

const {
  get,
  Route,
} = Ember;

export default Route.extend(CheckinByDate, AuthenticatedRouteMixin, {
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
    if (typeof FastBoot !== 'undefined') { return; }

    transition.abort();

    if (get(this, 'session.isAuthenticated')) {
      get(this, 'session.currentUser').then(currentUser => {
        get(currentUser, 'profile').then(profile => {
          if (get(profile, 'isOnboarded')) {
            const date = moment(new Date()).format('YYYY-MM-DD');

            this.checkinByDate(date).then(
              () => {
                this.routeToCheckinsForDate(date);
              },
              () => {
                this.routeToNewCheckin(date);
              }
            );
          } else {
            this.transitionTo('onboarding', get(profile, 'onboardingStep.stepName'));
          }
        });
      });
    } else {
      return this._super(...arguments);
    }
  },
});
