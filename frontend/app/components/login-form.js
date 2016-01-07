import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service('store'),

  actions: {
    authenticateWithDevise() {
      let { identification, password } = this.getProperties('identification', 'password');
      this.get('session').authenticate('authenticator:devise', identification, password).catch((reason) => {
        this.set('errorMessage', reason.error);
      });
    }
  }
});
