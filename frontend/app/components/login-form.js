import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['login-form'],

  actions: {
    authenticateWithDevise() {
      let { identification, password } = this.getProperties('identification', 'password');
      this.get('session').authenticate('authenticator:devise', identification, password).catch((reason) => {
        this.set('errorMessage', reason.errors);
      });
    },
    authenticateWithFacebook() {
      this.get('session').authenticate('authenticator:facebook').catch((reason) => {
        this.set('errorMessage', reason);
      });
    }
  }

});
