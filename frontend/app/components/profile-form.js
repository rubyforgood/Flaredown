import Ember from 'ember';

export default Ember.Component.extend({

  selectableData: Ember.inject.service('selectable-data'),

  countries: Ember.computed.alias('selectableData.countries'),
  sexes: Ember.computed.alias('selectableData.sexes'),

  setSelectedSexId: Ember.on('didInsertElement', function() {
    this.get('model.sex').then(sex => {
      if (Ember.isPresent(sex)) {
        this.set('selectedSexId',  sex.get('id'));
      }
    });
  }),

  actions: {
    sexChanged(newId) {
      this.get('model').set('sex', this.get('sexes').findBy('id', newId));
    },

    saveProfile() {
      this.get('model').save().then( (profile) => {
        this.sendAction('onProfileSaved', profile);
      });
    }
  }

});
