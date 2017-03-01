import Ember from 'ember';

const {
  get,
  set,
  Component,
  getProperties,
} = Ember;

export default Component.extend({
  classNames: ['signup-form'],

  actions: {
    onCaptchaResolved(reCaptchaResponse) {
      set(this, 'model.captchaResponse', reCaptchaResponse);
    },

    save() {
      let model = get(this, 'model');

      const { email, password } = getProperties(model, 'email', 'password');

      set(model, 'passwordConfirmation', password);

      model
        .save()
        .then(() => get(this, 'session').authenticate('authenticator:devise', email, password))
        .catch(() => get(this, 'gRecaptcha').resetReCaptcha());
    },
  },
});
