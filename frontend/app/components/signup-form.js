import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['signup-form'],

  actions: {
    onCaptchaResolved(reCaptchaResponse) {
      this.get('model').set('captchaResponse', reCaptchaResponse);
    },

    save() {
      let model = this.get('model');
      model.set('passwordConfirmation', model.get('password'));
      model.save().then( () => {
        this.get('session').authenticate(
          'authenticator:devise',
          model.get('email'),
          model.get('password')
        );
      });
    }
  }

});
