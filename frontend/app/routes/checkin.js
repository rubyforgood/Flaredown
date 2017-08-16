import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  set,
  inject: {
    service,
  },
  RSVP,
  Route,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  fastboot: service(),

  beforeModel() {
    const store = get(this, 'store');

    if(store.peekAll('condition').length > 0){
      store.unloadAll('condition');
    }
  },

  model(params) {
    var checkinId = params.checkin_id;
    var stepId = `${this.routeName}-${params.step_key}`;
    const store = get(this, 'store');

    const makeRequest = get(this, 'fastboot.isFastBoot') || get(this, 'fastboot.appHasLoaded');

    const checkin = makeRequest ? this.requestData(store, checkinId) : this.peekData(store, checkinId);

    return RSVP.hash({
      stepId,
      checkin: checkin,
    });
  },

  afterModel(model) {
    set(this, 'stepsService.checkin', model.checkin);

    this._super(...arguments);
  },

  requestData(store, checkinId) {
    return store.findRecord('checkin', checkinId);
  },

  peekData(store, checkinId) {
    return RSVP.resolve(store.peekRecord('checkin', checkinId));
  },
});
