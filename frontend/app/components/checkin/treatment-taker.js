import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

export default Ember.Component.extend(SearchableDropdown, {

  classNames: ['treatment-taker'],

  isEditMode: false,
  treatment: Ember.computed.alias('model.treatment'),
  dose: Ember.computed.alias('model.dose'),
  isTaken: Ember.computed.alias('model.isTaken'),

  isTakenObserver: Ember.observer('isTaken', function() {
    this.get('onIsTakenChanged')();
  }),

  allTreatmentDoses: Ember.computed('treatment', function() {
    return this.customSearch({
      resource: 'dose',
      query: {
        treatment_id: this.get('treatment.id')
      }
    });
  }),

  changeDose(newDose) {
    this.get('model').set('dose', newDose);
    this.set('isEditMode', false);
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
      // TODO: auto-focus the select
    },

    clearDose() {
      this.changeDose(null);
      this.get('onDoseChanged')();
    },

    handleChange(dose) {
      this.changeDose(dose);
      this.get('onDoseChanged')(dose);
    },

    createDose(name) {
      let dose = this.createRecord('dose', name);
      this.changeDose(dose);
      this.get('onDoseChanged')(dose);
    },

    handleFocus() {
      // TODO remove debug log when this is fixed:
      // https://github.com/cibernox/ember-power-select/issues/739
      Ember.Logger.debug('focus');
      this.set('isSelectFocused', true);
    },
    handleBlur() {
      // TODO remove debug log when this is fixed:
      // https://github.com/cibernox/ember-power-select/issues/739
      Ember.Logger.debug('blur');
      this.set('isSelectFocused', false);
    },
  },

  performSearch(term, resolve, reject) {
    this
      .customSearch({
        resource: 'dose',
        query: {
          treatment_id: this.get('treatment.id'),
          name: term,
        }
      })
      .then(function() { resolve(...arguments) }, reject);
  },
});
