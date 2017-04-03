import Ember from 'ember';

const {
  get,
  observer,
  Controller,
  setProperties,
  run: {
    debounce,
  },
} = Ember;

export default Controller.extend({
  query: '',

  searchFieldObserver: observer('query', function() {
    debounce(this, this.searchPosts, 200);
  }),

  searchPosts() {
    this
      .store
      .query('post', { query: get(this, 'query') })
      .then(posts => setProperties(this, { page: 1, model: posts.toArray() }));
  },
});
