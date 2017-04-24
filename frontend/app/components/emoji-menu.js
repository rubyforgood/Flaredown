import Ember from 'ember';

const {
  get,
  set,
  computed,
  Component,
  setProperties,
  Logger: { debug },
  inject: { service },
} = Ember;

export default Component.extend({
  visible: false,

  emojis: service(),

  selectedGroup: computed('selected', function() {
    return get(this, `emojis.groupedStyledMap.${get(this, 'selected')}`);
  }),

  init() {
    this._super(...arguments);
    this.setGroupsSelection();
  },

  setGroupsSelection(groupName = 'smile') {
    let result = {};

    get(this, 'emojis.groups').forEach(group => {
      result[`${group}Class`] = `icon-${group}${group === groupName ? '-selected' : ''}`;
    });

    result.selected = groupName;

    setProperties(this, result);
  },

  onSelect(emojiTitle) {
    debug(emojiTitle, "was selected. Pass 'onSelect' callback to take some action...");
  },

  actions: {
    noAction() {},

    toggleMenu() {
      set(this, 'visible', !get(this, 'visible'));
    },

    selectGroup(groupName) {
      this.setGroupsSelection(groupName);
    },

    selectIcon(emojiTitle) {
      this.onSelect(emojiTitle);

      set(this, 'visible', false);
    },
  },
});
