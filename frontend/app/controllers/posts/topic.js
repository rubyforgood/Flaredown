import Ember from 'ember';

const {
  set,
  observer,
  Controller,
  getProperties,
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
    const { model, query } = getProperties(this, 'model', 'query');
    const { id, type } = getProperties(model, 'id', 'type');

    this.store.query('post', { id, type, query }).then(posts => set(model, 'posts', posts));
  },
});
