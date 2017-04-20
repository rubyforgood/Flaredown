import Ember from 'ember';

const {
  get,
  Component,
  getProperties,
} = Ember;

export default Component.extend({
  canReact: false,
  classNames: ['emoji-reactions'],

  actions: {
    onEmojiSelect(emojiTitle) {
      let reactions = get(this, 'reactable.reactions');
      const existentReaction = reactions.findBy('id', emojiTitle);

      if (existentReaction && get(existentReaction, 'participated')) {
        return;
      }

      const { reactable, store } = getProperties(this, 'reactable', 'store');

      let record = existentReaction || store.createRecord('reaction', {
        id: emojiTitle,
        reactable_id: get(reactable, 'id'),
        reactable_type: get(reactable, 'modelType'),
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
