import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

const {
  get,
  set,
  RSVP,
  Route,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, CheckinByDate, {
  beforeModel: function(transition){
    set(this, 'date', transition.queryParams.date);
  },

  model(params) {
    const date = get(this, 'date') || moment(new Date()).format('YYYY-MM-DD');

    this.checkinByDate(date).then(
      () => {
        this.routeToCheckin(date);
      },
      () => {
        this.routeToNewCheckin(date);
      }
    );
  },
});
