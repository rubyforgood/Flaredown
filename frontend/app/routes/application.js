import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {

  renderTemplate: function() {
    this.render();
    this.render('application/header', {
      into: 'application',
      outlet: 'header',
    });
    this.render('application/footer', {
      into: 'application',
      outlet: 'footer',
    });
  },

  actions: {
    invalidateSession() {
      this.get('session').invalidate();
    }
  }
});
