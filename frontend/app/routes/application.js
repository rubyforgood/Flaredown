import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {

  actions: {
    routeToLogin() {
      this.router.transitionTo('login');
    },

    openModal: function(modalName, model, controller) {
      this.send('closeModal');

      if(Ember.isEmpty(controller)) {
        try {
          controller = this.controllerFor(modalName);
        } catch(err) {
          controller = this.controllerFor('application');
        }
      }

      this.render(modalName, {
        outlet: 'modal',
        into: 'application',
        controller: controller,
        model: model
      });
    },

    closeModal: function() {
      this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    }

  }

});
