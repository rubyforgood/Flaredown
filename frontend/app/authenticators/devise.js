import Devise from 'ember-simple-auth/authenticators/devise';
import ENV from 'flaredown/config/environment';


export default Devise.extend({
  serverTokenEndpoint: `${ENV.apiHost}/api/sessions`,
});
