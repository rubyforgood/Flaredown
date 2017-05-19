import Ember from 'ember';

const {
  computed: {
    alias
  },
  inject: {
    service
  },
  Mixin,
} = Ember;

export default Mixin.create({
  session: service('session'),
  dataStore: service('store'),

  screenName: alias('session.actualUser.profile.screenName'),
});
