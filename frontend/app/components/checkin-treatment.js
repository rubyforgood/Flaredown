import Ember from 'ember';

export default Ember.Component.extend({

  classNames: ['checkin-treatment'],

  isEditMode: false,
  treatment: Ember.computed.alias('model.treatment'),
  dose: Ember.computed.alias('model.dose'),
  isTaken: Ember.computed.alias('model.isTaken'),

  isTakenObserver: Ember.observer('isTaken', function() {
    this.get('onIsTakenChanged')();
  }),

  doseQueryParams: Ember.computed('treatment', function() {
    return {treatment_id: this.get('treatment.id')};
  }),

  unsetEditMode() {
    // we need to wait before unsetting edit mode
    // to avoid selectize being destroyed too early
    Ember.run.later(() => {
      this.set('isEditMode', false);
    }, 100);
  },

  actions: {
    titleClicked() {
      this.get('onTitleClicked')(this.get('model.id'));
    },

    removeTreatment() {
      this.get('onRemove')(this.get('model'));
    },

    edit() {
      this.set('isEditMode', true);
      Ember.run.next(() => {
        this.$('input').focus();
      });
    },

    doneEditing() {
      if (Ember.isPresent(this.get('dose'))) {
        this.get('onDoseChanged')();
        this.unsetEditMode();
      }
    },

    cancelEditing() {
      this.unsetEditMode();
    },

    clearDose() {
      this.get('model').set('dose', null);
      this.get('onDoseChanged')();
      this.unsetEditMode();
    }

  }
});
