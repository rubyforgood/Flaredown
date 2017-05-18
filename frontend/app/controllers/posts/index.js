import Ember from 'ember';
import SearchableDropdown from 'flaredown/mixins/searchable-dropdown';
import NavbarSearchable from 'flaredown/mixins/navbar-searchable';

const {
  get,
  set,
  computed,
  Controller,
  getProperties,
  setProperties,
} = Ember;

export default Controller.extend(SearchableDropdown, NavbarSearchable, {
  page: 1,
  queryParams: ['following', 'query'],
  following: null,
  querySearch: '',
  foundTopics: null,

  myTopicsText: computed('model.topicFollowing.topicsCount', function() {
    return `My topics (${get(this, 'model.topicFollowing.topicsCount')})`;
  }),

  randomTrackables: computed(function() {
    return this.randomSearch('topic');
  }),

  actions: {
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
