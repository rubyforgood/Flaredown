import Ember from 'ember';
import AjaxService from 'ember-ajax/services/ajax';
import ENV from 'flaredown/config/environment';

const {
  get,
  computed,
  getProperties,
  inject: {
    service,
  },
} = Ember;

export default AjaxService.extend({
  namespace: 'api',
  host: ENV.apiHost,

  session: service(),

  headers: computed('session.data.authenticated.uid', function() {
    const authenticated = get(this, 'session.data.authenticated');

    if(!authenticated) { return {}; }

    const { email, token } = getProperties(authenticated, 'email', 'token');

    return { Authorization: `Token token="${token}", email="${email}"` };
  }),
});
