import Ember from 'ember';
import FacebookAuthAction from 'flaredown/mixins/facebook-auth-action';

export default Ember.Component.extend(FacebookAuthAction, {

  classNames: ['login-form'],

  actions: {
    authenticateWithDevise() {
      let { identification, password } = this.getProperties('identification', 'password');
      this.get('session').authenticate('authenticator:devise', identification, password).catch((reason) => {
        this.set('errorMessage', reason.errors);
      });
    }
  }

});
