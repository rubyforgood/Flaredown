import Ember from 'ember';
import BackNavigateable from 'flaredown/mixins/back-navigateable';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  computed,
  Controller,
  String: {
    htmlSafe,
  },
} = Ember;

export default Controller.extend(BackNavigateable, SearchableDropdown, {
  closeSymbol: htmlSafe('&#10005&nbsp;&nbsp;'),

  randomTrackables: computed(function() {
    return this.randomSearch('topic');
  }),

  performSearch(term, resolve, reject) {
    this
      .searchByTerm('topic', term)
      .then(function() { resolve(...arguments); }, reject);
  },

  manipulateTopic(topic, action) {
    const model = get(this, 'model');

    model[action](topic);
    model.save();
  },

  actions: {
    addTopic(topic) {
      this.manipulateTopic(topic, 'addTopic');
    },

    removeTopic(topic) {
      this.manipulateTopic(topic, 'removeTopic');
    },
  },
});
