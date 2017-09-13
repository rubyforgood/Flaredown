import Ember from 'ember';

const {
  get,
  set,
  Component
} = Ember;

export default Component.extend({
  showReminder: false,

  actions: {
    saveProfile() {
      set(this, 'isLoading', true);

      get(this, 'model').save().then(profile => {
        this.sendAction('onProfileSaved', profile);
      }).finally(() => {
        set(this, 'isLoading', false);
      });

    },
  },
});
