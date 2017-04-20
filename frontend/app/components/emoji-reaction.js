import Ember from 'ember';

const {
  get,
  computed,
  Component,
  getProperties,
  computed: {
    alias,
  },
} = Ember;

export default Component.extend({
  tagName: 'a',
  classNames: ['emoji-reaction'],
  classNameBindings: ['isParticipated'],

  isParticipated: alias('reaction.participated'),

  style: computed('reaction.id', function() {
    return get(this, `emojis.styledMap.${get(this, 'reaction.id')}`);
  }),

  click() {
    let { store, reaction } = getProperties(this, 'store', 'reaction');
    let {
      participated,
      reactable_id,
      reactable_type,
    } = getProperties(reaction, 'participated', 'reactable_id', 'reactable_type');

    if (participated) {
      reaction
        .destroyRecord()
        .then(() => store.findRecord(reactable_type.toLowerCase(), reactable_id));
    } else {

    }
  },
});
