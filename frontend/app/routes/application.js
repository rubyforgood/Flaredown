import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {

  actions: {
    openModal: function(modalName, model, controller) {
      this.send('closeModal');

      controller = controller || this.controllerFor(modalName);

      if (model) {
        controller.set('model', model);
      }

      this.render(modalName, {
        outlet: 'modal',
        into: 'application',
        controller: controller
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
