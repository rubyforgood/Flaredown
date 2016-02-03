import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {

  model(params) {
    var checkinId = params.checkin_id;
    var stepId = `${this.routeName}-${params.step_key}`;
    return Ember.RSVP.hash({
      checkin: this.store.find('checkin', checkinId),
      currentStep: this.store.find('step', stepId)
    });
  }

});
