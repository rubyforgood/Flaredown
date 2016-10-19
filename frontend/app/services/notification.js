import Ember from 'ember';

export default Ember.Service.extend({
  pusher: Ember.inject.service(),
  session: Ember.inject.service(),

  notificationChannel: Ember.computed.alias('session.settings.notificationChannel'),
  notifications: Ember.A([]),

  init() {
    this._super(...arguments);
    this.subscribe();
  },

  subscribe() {
    var notificationChannel = this.get('notificationChannel');

    if(Ember.isPresent(notificationChannel)) {
      this.get('pusher').subscribe(notificationChannel, {
        notificatonEvent: (data) => {
          this.handleEvent(data);
        }
      });
    }
  },

  handleEvent(data) {
    Ember.debug("notificatonEvent: " +  Ember.inspect(data));
  }

});
