import Ember from 'ember';

const {
  get,
  computed,
  Component,
  computed: {
    alias,
  },
} = Ember;

export default Component.extend({
  classNames: ['emoji-reaction'],
  classNameBindings: ['isParticipated'],

  isParticipated: alias('reaction.participated'),

  style: computed('reaction.id', function() {
    return get(this, `emojis.styledMap.${get(this, 'reaction.id')}`);
  }),

  actions: {
    toggleReaction() {
      console.log('toggleReaction'); //DEBUG
    },
  },
});
