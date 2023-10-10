import Ember from 'ember';
import ENV from 'flaredown/config/environment';
import Pusher from 'pusher-js';

export default Ember.Object.extend({
  setConnection: Ember.on('init', function() {
    this.set('client', new Pusher(ENV.pusher.key, {
      encrypted: true,
      authEndpoint: `${ENV.apiHost}/api/pusher`,
      auth: {
        headers: {
          'Authorization': `Token token="${this.get('token')}", email="${this.get('email')}"`
        }
      }
    }));
    this.get('client').connection.bind('connected', this.onConnected.bind(this) );
  }),

  onConnected() {
  }
});
