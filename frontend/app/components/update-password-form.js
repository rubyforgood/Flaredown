import Ember from 'ember';

const {
  set,
  Component
} = Ember;

export default Component.extend({
  classNames: ['update-password-form'],


  actions: {
    updatePassword(){
      set(this, 'isLoading', true);

      this.get('model').save().then( (password) => {
        this.sendAction('onPasswordUpdated', password);
      }).finally(() => {
        set(this, 'isLoading', false);
      });
    }
  }
});
