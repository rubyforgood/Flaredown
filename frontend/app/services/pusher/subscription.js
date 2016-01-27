import Ember from 'ember';

export default Ember.Object.extend({
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
