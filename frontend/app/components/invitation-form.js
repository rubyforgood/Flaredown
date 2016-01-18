import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['invitation-form'],

  actions: {
    acceptInvitation() {
      var model = this.get('model');
      model.set('passwordConfirmation', model.get('password'));
      model.save().then( () => {
        this.get('session').authenticate('authenticator:devise', model.get('email'), model.get('password') );
      });
    }
  }

});
