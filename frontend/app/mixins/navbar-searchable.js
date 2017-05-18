import Ember from 'ember';

const {
  set,
  getProperties,
} = Ember;

export default Ember.Mixin.create({
  performSearch(term, resolve, reject) {
    this
      .searchByTerm('topic', term)
      .then((topics) => {
        set(this, 'foundTopics', topics);
        resolve(topics);
      }, reject);
  },

  actions: {
    goToTopic(topic) {
      // TODO: check on NULL

      const { id, modelType } = getProperties(topic, 'id', 'modelType');

      this.transitionToRoute('posts.topic', modelType, id);
    },
  }
});
