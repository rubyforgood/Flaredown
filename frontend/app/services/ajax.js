import Ember from 'ember';
import AjaxService from 'ember-ajax/services/ajax';

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

  session: service(),

  headers: computed('session.data.authenticated.uid', function() {
    const { email, token } = getProperties(get(this, 'session.data.authenticated'), 'email', 'token');

    return { Authorization: `Token token="${token}", email="${email}"` };
  }),
});
