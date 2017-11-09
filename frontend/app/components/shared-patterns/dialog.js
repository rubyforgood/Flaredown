import Ember from 'ember';
import config from 'flaredown/config/environment';
import CryptoJS from 'cryptojs';

const {
  get,
  set,
  observer,
  inject: {
    service,
  },
  Component,
} = Ember;

export default Component.extend({
  i18n: service(),

  classNames: ['flaredown-white-box', 'sharedPatternsDialog'],

  secretPhrase: config.encryptionSecret,
  staticUrl: config.staticUrl,
  nothingChecked: true,

  isCheckedSomeObserver: observer('patterns.@each.checked', function() {
    const checkedPatternIds = get(this, 'patterns').filter((pattern) => pattern.checked).map((pattern) => pattern.id);

    set(this, 'nothingChecked', checkedPatternIds.length == 0);
    const encryptedParams = CryptoJS.AES.encrypt(checkedPatternIds.join(', '), get(this, 'secretPhrase'));

    const friendlyUrl = get(this, 'staticUrl') + '/patterns/' + encodeURIComponent(encryptedParams);

    set(this, 'encryptedUrl', friendlyUrl);
  }),

  actions: {
    sharedPatterns() {
      const encryptedUrl = encodeURIComponent(get(this, 'encryptedUrl'));
      const currentUser = get(this, 'session.currentUser');
      const screenName = currentUser ?  get(currentUser, 'profile.screenName') : "";
      const subject = `User ${screenName} shared Health patterns with you`;

      window.location.href = `mailto:?subject=${subject}&body=${encryptedUrl}`;
    },
  },
});
