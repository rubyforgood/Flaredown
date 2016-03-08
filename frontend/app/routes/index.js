/* global moment */
import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import OnboardedRoute from 'flaredown/mixins/onboarded-route';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

export default Ember.Route.extend(CheckinByDate, OnboardedRoute, AuthenticatedRouteMixin, {

  /*
    If the user has already checked-in today, default route when they open the app should be the chart.
    If the user has no check-in today, default route should be today's check-in.
  */
  beforeModel(transition) {
    if (this.get('session.isAuthenticated')) {
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
      return this._super(...arguments);
    }
  }

});
