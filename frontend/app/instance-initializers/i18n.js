export default {
  name: 'i18n',

  initialize(application) {
    let i18n = application.lookup('service:i18n');
    const lang = navigator.language || navigator.userLanguage;

    i18n.set('locale', i18n.get('locales').includes(lang) ? lang : 'en');

    application.inject('service:steps', 'i18n', 'service:i18n');
  },
};
