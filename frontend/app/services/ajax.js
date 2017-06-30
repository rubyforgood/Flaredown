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
    const { email, token } = getProperties(get(this, 'session.data.authenticated'), 'email', 'token');

    return { Authorization: `Token token="${token}", email="${email}"` };
  }),
});
