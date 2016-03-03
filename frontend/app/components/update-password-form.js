import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['update-password-form'],


  actions: {
    updatePassword(){
      this.get('model').save().then( (password) => {
        this.sendAction('onPasswordUpdated', password);
      });
    }
  }
});
