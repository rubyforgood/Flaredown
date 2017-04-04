import Ember from 'ember';

const {
  get,
  set,
  computed,
  observer,
  Controller,
  getProperties,
  setProperties,
  run: {
    debounce,
  },
} = Ember;

export default Controller.extend({
  page: 1,
  query: '',

  myTopicsText: computed('model.topicFollowing.topicsCount', function() {
    return `My topics (${get(this, 'model.topicFollowing.topicsCount')})`;
  }),

  searchFieldObserver: observer('query', function() {
    debounce(this, this.searchPosts, 200);
  }),

  searchPosts() {
    this
      .store
      .query('post', { query: get(this, 'query') })
      .then(posts => setProperties(this, { page: 1, 'model.posts': posts.toArray() }));
  },

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
