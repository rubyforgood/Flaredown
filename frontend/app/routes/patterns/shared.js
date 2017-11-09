import Ember from 'ember';
import config from 'flaredown/config/environment';
import CryptoJS from 'cryptojs';

const {
  get,
  set,
  RSVP: {
    hash,
  },
  setProperties,
  Route,
} = Ember;

export default Route.extend({
  secretPhrase: config.encryptionSecret,
  staticUrl: config.staticUrl,

  model(params) {
    const friendlyUrl = decodeURIComponent(params.friendly_id);
    const decryptedArray = CryptoJS.AES.decrypt(friendlyUrl, get(this, 'secretPhrase')).toString(CryptoJS.enc.Utf8);
    const patternIds = decryptedArray.split(', ').map((id) => id.replace(/\s+/g,""));

    return get(this, 'store').query('pattern', { pattern_ids: patternIds });
  },
});
