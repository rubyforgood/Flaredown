import Ember from 'ember';

const {
  get,
  Component,
  getProperties,
} = Ember;

export default Component.extend({
  classNames: ['emoji-reactions'],

  actions: {
    onEmojiSelect(emojiTitle) {
      let reactions = get(this, 'post.reactions');
      const existentReaction = reactions.findBy('id', emojiTitle);

      if (existentReaction && get(existentReaction, 'participated')) {
        return;
      }

      const { post, store } = getProperties(this, 'post', 'store');

      let record = existentReaction || store.createRecord('reaction', {
        id: emojiTitle,
        reactable_id: get(post, 'id'),
        reactable_type: get(post, 'modelType'),
      });

      record
        .save()
        .then(reaction => {
          if (!existentReaction) {
            reactions.pushObject(reaction);
          }
        });
    },
  },
});
