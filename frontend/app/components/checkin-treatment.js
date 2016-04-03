import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['checkin-treatment'],

  isEditMode: false,
  treatment: Ember.computed.alias('model.treatment'),
  isTaken: Ember.computed.alias('model.isTaken'),

  isTakenObserver: Ember.observer('isTaken', function() {
    this.get('onIsTakenChanged')();
  }),

  doseQueryParams: Ember.computed('treatment', function() {
    return {treatment_id: this.get('treatment.id')};
  }),

  actions: {

    xClick() {
      this.get('onRemove')(this.get('model'));
    },

    edit() {
      this.set('dosePreviousValue', this.get('model.value'));
      this.set('isEditMode', true);
    },

    doneEditing() {
      this.get('model').set('value', this.get('selectedDose.name'));
      this.get('onDoseChanged')();
      // we need to wait before unsetting edit mode
      // to avoid selectize being destroyed too early
      Ember.run.later(() => {
        //stay in edit mode when user deletes selection
        if (Ember.isNone(this.get('dosePreviousValue')) ||
            Ember.isPresent(this.get('model.value'))) {
          this.set('isEditMode', false);
        }
        this.set('dosePreviousValue', this.get('model.value'));
      }, 100);
    }

  }
});
