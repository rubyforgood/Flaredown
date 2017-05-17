import Ember from 'ember';
import DS from 'ember-data';

const {
  get,
  computed,
  inject: {
    service
  },
  Mixin,
} = Ember;

const { PromiseObject } = DS;

export default Mixin.create({
  session: service('session'),
  dataStore: service('store'),

  screenName: computed(function() {
    return PromiseObject.create({
      promise: get(this, 'session.currentUser').then((u) => get(u, 'profile').then(p => get(p, 'screenName')))
    });
  }),
});
