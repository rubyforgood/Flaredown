import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  RSVP,
  Route,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  model(params) {
    var checkinId = params.checkin_id;
    var stepId = `${this.routeName}-${params.step_key}`;

    const currentStep = get(this, `stepsService.steps.${stepId}`);

    return RSVP.hash({
      currentStep,
      checkin: this.store.find('checkin', checkinId),
    });
  }
});
