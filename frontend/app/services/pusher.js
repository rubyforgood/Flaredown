import Ember from 'ember';
import Connection from 'flaredown/services/pusher/connection';
import Subscription from 'flaredown/services/pusher/subscription';


export default Ember.Service.extend({
  session: Ember.inject.service(),

  setConnection: Ember.on('init', function() {
    this.set('connection', Connection.create({ email: this.get('session.email'), token: this.get('session.token') }) );
  }),

  subscribe(channelName, mixin) {
    return Subscription.extend(Ember.Mixin.create(mixin), { channelName: channelName, connection: this.get('connection') }).create();
  }

});
