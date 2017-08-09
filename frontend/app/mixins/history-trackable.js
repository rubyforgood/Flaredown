import Ember from 'ember';

const {
  get,
  Mixin,
  inject: {
    service,
  },
} = Ember;

export default Mixin.create({
  routeHistory: service(),

  afterModel(model, transition) {
    this._super(...arguments);

    get(this, 'routeHistory').pushEntry(this.historyEntry(model, transition));
  },

  historyEntry(model, transition) {
    // Redefine this method in every route this mixin included to if it relies on params
    // It should return an array of route name and params
    // return null if the route should be skipped from adding to history
    return [transition.targetName];
  },
});
