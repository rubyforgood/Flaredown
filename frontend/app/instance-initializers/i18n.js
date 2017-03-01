export default {
  name: 'i18n',

  initialize(application) {
    application.lookup('service:i18n').set('locale', navigator.language || 'en-GB');

    application.inject('service:steps', 'i18n', 'service:i18n');
  },
};
