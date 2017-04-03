import Ember from 'ember';

const {
  get,
  set,
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

  searchFieldObserver: observer('query', function() {
    debounce(this, this.searchPosts, 200);
  }),

  searchPosts() {
    this
      .store
      .query('post', { query: get(this, 'query') })
      .then(posts => setProperties(this, { page: 1, model: posts.toArray() }));
  },

  actions: {
    crossedTheLine(above) {
      if (above) {
        let { page, model, query } = getProperties(this, 'page', 'model', 'query');

        set(this, 'loadingPosts', true);

        page += 1;

        this
          .store
          .query('post', { page, query })
          .then(newPosts => {
            setProperties(this, { page, loadingPosts: false });

            model.pushObjects(newPosts.toArray());
          });
      }
    },
  },
});
