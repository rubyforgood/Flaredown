import config from 'flaredown/config/environment';
import CryptoJS from 'cryptojs';
import Component from '@ember/component';
import { get, set, computed } from '@ember/object';

export default Component.extend({
  classNames: ['flaredown-white-box', 'sharedChartsDialog'],

  secretPhrase: config.encryptionSecret,
  staticUrl: config.staticUrl,

  encryptedUrl: computed('session.isAuthenticated', 'session.email', function() {
    if(get(this, 'session.isAuthenticated')) {
      const email = get(this, 'session.email');
      const encryptedEmail = CryptoJS.AES.encrypt(email, get(this, 'secretPhrase'));

      return `${get(this, 'staticUrl')}/charts/${encodeURIComponent(encryptedEmail)}`;
    } else {
      return '';
    }
  }),

  actions: {
    sendEmail() {
      const encryptedUrl = encodeURIComponent(get(this, 'encryptedUrl'));
      const currentUser = get(this, 'session.currentUser');
      const screenName = currentUser ?  get(currentUser, 'profile.screenName') : "";
      const subject = `${screenName} would like to share their health charts with you`;

      window.location.href = `mailto:?subject=${subject}&body=${encryptedUrl}`;
    },
  },
});
