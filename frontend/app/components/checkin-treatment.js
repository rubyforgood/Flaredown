import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['checkin-treatment'],

  store: Ember.inject.service(),

  isEditMode: false,
  treatment: Ember.computed.alias('model.treatment'),
  isTaken: Ember.computed.alias('model.isTaken'),

  doseQueryParams: Ember.computed('treatment', function() {
    return {treatment_id: this.get('treatment.id')};
  }),

  actions: {

    xClick() {
      this.get('onRemove')(this.get('model'));
    },

    edit() {
      this.set('isEditMode', true);
    },

    doneEditing() {
      this.get('model').set('value', this.get('selectedDose.name'));
      this.set('isEditMode', false);
    }

  }
});
