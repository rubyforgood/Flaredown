import Ember from 'ember';
import DS from 'ember-data';
import BackNavigateable from 'flaredown/mixins/back-navigateable';

const {
  get,
  computed,
  inject: {
    service
  }
} = Ember;

export default Ember.Controller.extend(BackNavigateable, {
  notifications: service('notifications'),
  session: service('session'),
  dataStore: service('store'),

  screenName: computed(function() {
    return DS.PromiseObject.create({
      promise: get(this, 'session.currentUser').then((u) => get(u, 'profile').then(p => get(p, 'screenName')))
    });
  }),
});
