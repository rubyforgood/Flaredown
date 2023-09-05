import Ember from 'ember';
import BackNavigateable from 'flaredown/mixins/back-navigateable';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  computed,
  Controller,
  getProperties,
} = Ember;

export default Controller.extend(BackNavigateable, SearchableDropdown, {
  disabled: computed('model.{body,title,topics.[]}', function() {
    const { body, title, topics } = getProperties(get(this, 'model'), 'body', 'title', 'topics');

    return !(body && title && topics.length);
  }),

  randomTrackables: computed(function() {
    return this.randomSearch('topic');
  }),

  performSearch(term, resolve, reject) {
    this
      .searchByTerm('topic', term)
      .then(function() { resolve(...arguments); }, reject);
  },

  actions: {
    addTopic(topic) {
      get(this, 'model').addTopic(topic);
    },

    savePost() {
      get(this, 'model')
        .save()
        .then(post => this.transitionToRoute('posts.show', post));
    },

    removeTopic(topic) {
      get(this, 'model').removeTopic(topic);
    },
  },
});
