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
    const decryptedArray = CryptoJS.AES.decrypt(friendlyUrl, get(this, 'secretPhrase')).toString(CryptoJS.enc.Utf8).split(':');
    const endAt = moment(decryptedArray.pop());
    const startAt = moment(decryptedArray.pop());

    setProperties(this, { endAt: endAt, startAt: startAt });

    const patternIds = decryptedArray[0].split(', ').map((id) => id.replace(/\s+/g,""));

    return get(this, 'store').query('pattern', { pattern_ids: patternIds });
  },

  setupController(controller, model) {
    this._super(controller, model);

    const startAt = get(this, 'startAt') || moment().subtract(14, 'days').format('YYYY-MM-DD');
    const endAt = get(this, 'endAt') || moment().format('YYYY-MM-DD');

    setProperties(controller, { startAt: startAt, endAt: endAt });
  }
});
