import Ember from 'ember';

export default Ember.Component.extend({
  classNames: 'navigation-bar',

  pusher: Ember.inject.service(),

  subscribe: Ember.on('init', Ember.observer('session.notificationChannel', function(){
    var notificationChannel = this.get('session.notificationChannel');

    if(Ember.isPresent(notificationChannel)) {
      this.get('pusher').subscribe(notificationChannel, {
        notificatonEvent: (data) => {
          Ember.debug("notificatonEvent: " +  Ember.inspect(data));
        }
      });
    }

  })),

  actions: {
    invalidateSession() {
      this.get('session').invalidate();
    },

    openEditProfileModal() {
      this.get('session.currentUser.profile').then( (profile) => {
        Ember.getOwner(this).lookup('route:application').send('openModal', 'modals/edit-profile', profile);
      });

    },

  }

});
