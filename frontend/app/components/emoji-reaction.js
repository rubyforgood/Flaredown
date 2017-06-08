import Ember from 'ember';

const {
  get,
  computed,
  Component,
  getProperties,
  inject: { service },
  computed: {
    alias,
  },
} = Ember;

export default Component.extend({
  tagName: 'a',
  classNames: ['emoji-reaction'],
  classNameBindings: ['isParticipated'],

  emojis: service(),
  session: service(),

  isParticipated: alias('reaction.participated'),

  style: computed('reaction.value', function() {
    return get(this, `emojis.styledMap.${get(this, 'reaction.value')}`);
  }),

  click() {
    if(!get(this, 'session.isAuthenticated')) {
      return;
    }
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
      this.onParticipate(get(reaction, 'value'));
    }
  },
});
