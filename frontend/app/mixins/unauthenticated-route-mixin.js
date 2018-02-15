import Ember from 'ember';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Mixin.create(UnauthenticatedRouteMixin, {

  init() {
    this._super(...arguments);

    if(this.get('session.fullStoryInitialized')) {
      this.teardownFullStoryUser();
    }
  },

  teardownFullStoryUser() {
    this.set('session.fullStoryInitialized', false);
  },
});
