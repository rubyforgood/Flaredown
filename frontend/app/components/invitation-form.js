import Ember from 'ember';

export default Ember.Component.extend({

  actions: {
    acceptInvitation() {
      var model = this.get('model');
      model.save().then( () => {
        this.get('session').authenticate('authenticator:devise', model.get('email'), model.get('password') );
      });
    }
  }

});
