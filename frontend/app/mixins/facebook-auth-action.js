import Ember from 'ember';

export default Ember.Mixin.create({

  actions: {
    authenticateWithFacebook() {
      this.get('session').authenticate('authenticator:facebook').catch((reason) => {
        this.set('errorMessage', reason);
      });
    }
  }

});
