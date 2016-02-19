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
      // we need to wait before unsetting edit mode
      // to avoid selectize being destroyed too early
      Ember.run.later(() => {
        this.set('isEditMode', false);
      }, 100);
    }

  }
});
