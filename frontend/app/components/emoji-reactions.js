import Ember from 'ember';

const {
  get,
  Component,
  getProperties,
} = Ember;

export default Component.extend({
  actions: {
    onEmojiSelect(emojiTitle) {
      let reactions = get(this, 'post.reactions');
      const existentReaction = reactions.findBy('id', emojiTitle);

      if (existentReaction && existentReaction.participated) {
        return;
      }

      const { post, store } = getProperties(this, 'post', 'store');

      store.createRecord('reaction', {
        id: emojiTitle,
        reactable_id: get(post, 'id'),
        reactable_type: get(post, 'modelType'),
      }).save();
    },
  },
});
