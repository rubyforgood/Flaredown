import Ember from 'ember';
import AmplitudeAnalytics from 'flaredown/mixins/amplitude-analytics';

const {
  get,
  set,
  Component,
  getProperties,
} = Ember;

export default Component.extend(AmplitudeAnalytics, {
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
        .then(() => this.amplitudeLog('User signup'))
        .then(() => get(this, 'session').authenticate('authenticator:devise', email, password))
        .catch(() => get(this, 'gRecaptcha').resetReCaptcha());
    },
  },
});
