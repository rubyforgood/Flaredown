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
  query: '',

  searchFieldObserver: observer('query', function() {
    debounce(this, this.searchPosts, 200);
  }),

  isFollowed: computed('model.topicFollowing.updatedAt', function() {
    const { id, type, topicFollowing } = getProperties(get(this, 'model'), 'id', 'type', 'topicFollowing');

    return get(topicFollowing, `${type}Ids`).includes(parseInt(id));
  }),

  searchPosts() {
    const page = 1;
    const { model, query } = getProperties(this, 'model', 'query');
    const { id, type } = getProperties(model, 'id', 'type');

    this
      .store
      .query('post', { id, type, query, page })
      .then(posts => setProperties(this, { page, 'model.posts': posts.toArray() }));
  },

  actions: {
    toggleTopicFollowing() {
      const { model, isFollowed } = getProperties(this, 'model', 'isFollowed');
      const { id, type, topicFollowing } = getProperties(model, 'id', 'type', 'topicFollowing');

      get(topicFollowing, `${type}Ids`)[isFollowed ? 'removeObject' : 'addObject'](parseInt(id));

      topicFollowing.save();
    },

    crossedTheLine(above) {
      if (above) {
        const { model, query } = getProperties(this, 'model', 'query');
        let { id, page, type, posts } = getProperties(model, 'id', 'page', 'type', 'posts');

        set(this, 'loadingTopics', true);

        page += 1;

        this
          .store
          .query('post', { id, type, query, page })
          .then(newPosts => {
            setProperties(this, { 'model.page': page, loadingTopics: false });

            posts.pushObjects(newPosts.toArray());
          });
      }
    },
  },
});
