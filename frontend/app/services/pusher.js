import Ember from 'ember';
import ENV from 'flaredown/config/environment';


var Connection = Ember.Object.extend({
  setConnection: Ember.on('init', function() {
    this.set('client', new window.Pusher(ENV.pusher.key, {
      encrypted: true,
      authEndpoint: '/api/pusher',
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

var Subscription = Ember.Object.extend({
  channelName: '',

  initSubscription: Ember.on('init', function() {
    this.get('connection.client').subscribe(this.get('channelName')) .bind_all(this.handlerEvents.bind(this));
  }),

  handlerEvents: function(eventName, data) {
    if(Ember.isPresent(eventName)) {
      Ember.tryInvoke(this, eventName, [data]);
    }
  }
});


export default Ember.Service.extend({
  session: Ember.inject.service(),

  setConnection: Ember.on('init', function() {
    this.set('connection', Connection.create({ email: this.get('session.email'), token: this.get('session.token') }) );
  }),

  subscribe(channelName, mixin) {
    return Subscription.extend(Ember.Mixin.create(mixin), { channelName: channelName, connection: this.get('connection') }).create();
  }

});
