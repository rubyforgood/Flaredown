import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  set,
  RSVP,
  Route,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  model(params) {
    var checkinId = params.checkin_id;
    var stepId = `${this.routeName}-${params.step_key}`;

    return RSVP.hash({
      stepId,
      checkin: this.store.find('checkin', checkinId),
    });
  },

  afterModel(model) {
    get(model.checkin, 'conditions')
      .then(conditions => RSVP.all(conditions.map(c => get(c, 'condition'))))
      .then(conditions => set(
        this,
        'stepsService.currentTrackables',
        conditions.map(condition => get(condition, 'name'))
      ));
  },
});
