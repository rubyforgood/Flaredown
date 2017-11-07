import Ember from 'ember';
import config from 'flaredown/config/environment';
import CryptoJS from 'cryptojs';

const {
  get,
  set,
  RSVP: {
    hash,
  },
  Route,
} = Ember;

export default Route.extend({
  secretPhrase: config.encryptionSecret,
  staticUrl: config.staticUrl,

  model(params) {
    const friendlyUrl = decodeURIComponent(params.friendly_id);
    const decrypted = CryptoJS.AES.decrypt(friendlyUrl, get(this, 'secretPhrase'));
    const patternIds = decrypted.toString(CryptoJS.enc.Utf8).split(', ').map((id) => id.replace(/\s+/g,""));

    return  hash({ patternIds: patternIds });
  },
});
