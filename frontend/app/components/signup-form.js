import Ember from 'ember';

const {
  get,
  set,
  Component,
  getProperties,
  computed
} = Ember;

export default Component.extend({
  classNames: ['signup-form'],

  isShowError: computed('model.birthDate.{year}', function() {
    return moment().year() - get(this, 'model.birthDate.year') < 16 || get(this, 'model.birthDate.year') === null;
  }),

  className: computed('isDisabled', function() {
    return get(this, 'isDisabled') ? 'btn btn-default left disabled' : 'btn btn-default left';
  }),

  isDisabled: computed('model.birthDate.{year,month,day}', 'model.acceptPrivacyTerms', function() {
    const year = get(this, 'model.birthDate.year');
    const month = get(this, 'model.birthDate.month');
    const day = get(this, 'model.birthDate.day');

    console.info(9999, year, month, day, get(this, 'model.acceptPrivacyTerms'))

    return get(this, 'isError') && (get(this, 'isShowError') || !year || !month || !day) || !get(this, 'model.acceptPrivacyTerms');
  }),

  isBlankError: computed('model.birthDate.{year,month,day}', function() {
    const year = get(this, 'model.birthDate.year');
    const month = get(this, 'model.birthDate.month');
    const day = get(this, 'model.birthDate.day');

    return year === null || month === null || day === null;
  }),

  actions: {
    onCaptchaResolved(reCaptchaResponse) {
      set(this, 'model.captchaResponse', reCaptchaResponse);
    },

    save() {
      const model = get(this, 'model');

      const year = get(this, 'model.birthDate.year');
      const month = get(this, 'model.birthDate.month');
      const day = get(this, 'model.birthDate.day');

      !year && set(this, 'model.birthDate.year', null);
      !month && set(this, 'model.birthDate.month', null);
      !day && set(this, 'model.birthDate.day', null);
      !get(this, 'model.acceptPrivacyTerms') && set(this, 'model.acceptPrivacyTerms', false);

      if (get(this, 'isDisabled')) {
        return;
      }

      const { email, password } = getProperties(model, 'email', 'password');

      set(model, 'passwordConfirmation', password);

      model
        .save()
        .then(() => get(this, 'session').authenticate('authenticator:devise', email, password))
        .catch(() => get(this, 'gRecaptcha').resetReCaptcha());
    },
  },
});
