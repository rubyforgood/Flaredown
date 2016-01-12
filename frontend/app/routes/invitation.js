import Ember from 'ember';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Route.extend(UnauthenticatedRouteMixin, {

  actions: {
    acceptInvitation() {
      var model = this.modelFor('invitation');
      model.save().then( () => {
        this.get('session').authenticate('authenticator:devise', model.get('user.email'), model.get('password') );
      });
    }

  }
});
