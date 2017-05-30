import Ember from 'ember';

const {
  on,
  get,
  set,
  compare,
  isPresent,
  Component,
  inject: {
    service,
  },
  computed: {
    sort,
    alias,
  },
} = Ember;

export default Component.extend({
  selectableData: service('selectable-data'),

  sexes: alias('selectableData.sexes'),

  countries: sort('selectableData.countries', function(itemA, itemB) {
    const nameA = get(itemA, 'name');
    const nameB = get(itemB, 'name');

    const us = 'United States';
    const gb = 'United Kingdom';

    return nameA === us ? -1 : nameB === us ? 1 : nameA === gb ? -1 : nameB === gb ? 1 : compare(nameA, nameB);
  }),

  setSelectedSexId: on('didInsertElement', function() {
    get(this, 'model.sex').then(sex => {
      if (isPresent(sex)) {
        set(this, 'selectedSexId', get(sex, 'id'));
      }
    });
  }),

  actions: {
    sexChanged(newId) {
      set(this, 'model.sex', get(this, 'sexes').findBy('id', newId));
    },

    saveProfile() {
      get(this, 'model').save().then(profile => {
        this.sendAction('onProfileSaved', profile);
      });
    },
  },
});
