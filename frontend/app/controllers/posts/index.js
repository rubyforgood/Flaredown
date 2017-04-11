import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';

const {
  get,
  set,
  computed,
  Controller,
  getProperties,
  setProperties,
} = Ember;

export default Controller.extend(SearchableDropdown, {
  page: 1,

  myTopicsText: computed('model.topicFollowing.topicsCount', function() {
    return `My topics (${get(this, 'model.topicFollowing.topicsCount')})`;
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
    goToTopic(topic) {
      const { id, modelType } = getProperties(topic, 'id', 'modelType');

      this.transitionToRoute('posts.topic', modelType, id);
    },

    crossedTheLine(above) {
      if (above) {
        let { page, model, query } = getProperties(this, 'page', 'model', 'query');
        let posts = get(model, 'posts');

        set(this, 'loadingPosts', true);

        page += 1;

        this
          .store
          .query('post', { page, query })
          .then(newPosts => {
            setProperties(this, { page, loadingPosts: false });

            posts.pushObjects(newPosts.toArray());
          });
      }
    },
  },
});
