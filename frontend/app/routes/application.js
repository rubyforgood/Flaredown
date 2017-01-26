import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

const {
  isEmpty,
  Route,
} = Ember;

export default Route.extend(ApplicationRouteMixin, {
  actions: {
    routeToLogin() {
      this.router.transitionTo('login');
    },

    openModal(modalName, model, controller) {
      this.send('closeModal');

      if(isEmpty(controller)) {
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

    closeModal() {
      this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    },
  },
});
