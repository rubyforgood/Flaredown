import Ember from 'ember';

export default Ember.Mixin.create({
  openProfileModal() {
    this
      .get('session.currentUser.profile')
      .then(profile =>
        Ember
          .getOwner(this)
          .lookup('route:application')
          .send('openModal', 'modals/edit-profile', profile)
      );
  },
});
