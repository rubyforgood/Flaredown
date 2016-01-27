import Ember from 'ember';

export default Ember.Service.extend({
  pusher: Ember.inject.service(),
  session: Ember.inject.service(),

  notificationChannel: Ember.computed.alias('session.extraSession.notificationChannel'),
  notifications: Ember.A([]),

  subscribe: Ember.on('init', Ember.observer('notificationChannel', function(){
    var notificationChannel = this.get('notificationChannel');

    if(Ember.isPresent(notificationChannel)) {
      this.get('pusher').subscribe(notificationChannel, {
        notificatonEvent: (data) => {
          this.handleEvent(data);
        }
      });
    }
  })),

  handleEvent(data) {
    Ember.debug("notificatonEvent: " +  Ember.inspect(data));
  }

});
