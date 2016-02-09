import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['checkin-treatment'],

  isEditMode: false,

  treatment: Ember.computed.alias('model.treatment'),
  isTaken: Ember.computed.alias('model.isTaken'),

  actions: {

    xClick() {
      this.get('onRemove')(this.get('model'));
    },

    edit() {
      this.set('isEditMode', true);
    },

    doneEditing() {
      this.set('isEditMode', false);
    }

  }
});
