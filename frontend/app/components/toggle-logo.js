import Ember from 'ember';

const {
  Component,
  computed,
  get,
  computed: {
    alias,
  },
  inject: {
    service,
  },
} = Ember;

export default Component.extend({
  logoVisiability: service(),
  i18n: service(),

  showHeaderLogo: alias('logoVisiability.showHeaderLogo'),
  showHeaderPath: alias('logoVisiability.showHeaderPAth'),

  currentPathTitle: computed('currentPath', 'i18n.locale', function() {
    const currentPath = get(this, 'currentPath');
    const i18n = get(this, 'i18n');

    switch(currentPath) {
      case 'password.update':
        return i18n.t('password.update.header').toString();
      case 'password.reset':
        return i18n.t('password.reset.header').toString();
      default:
        return currentPath;
    }
  }),
});
