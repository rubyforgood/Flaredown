import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';
import CheckinByDate from 'flaredown/mixins/checkin-by-date';

const {
  set,
  Route,
  RSVP,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, CheckinByDate, {
  beforeModel: function(transition){
    set(this, 'date', transition.queryParams.date);
  },

  model(params) {
    const date = params.date_key || moment(new Date()).format('YYYY-MM-DD');

    return RSVP.hash({ checkins: this.checkinByDate(date), date: date })
  },
});
