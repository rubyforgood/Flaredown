import Ember from 'ember';
import AuthenticatedRouteMixin from 'flaredown/mixins/authenticated-route-mixin';

const {
  get,
  set,
  setProperties,
  RSVP,
  Route,
} = Ember;

export default Route.extend(AuthenticatedRouteMixin, {
  queryParams: {
    start_at: { refreshModel: true },
    end_at: { refreshModel: true }
  },

  model(params) {
    setProperties(this, { startAt: params.start_at, endAt: params.end_at });

    return get(this, 'store').findAll('pattern');
  },

  setupController(controller, model) {
    this._super(controller, model);

    const startAt = get(this, 'startAt') || moment().subtract(14, 'days').format('YYYY-MM-DD');
    const endAt = get(this, 'endAt') || moment().format('YYYY-MM-DD');

    setProperties(controller, { startAt: startAt, endAt: endAt });
  }
});
