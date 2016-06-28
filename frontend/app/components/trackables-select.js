import Ember from 'ember';

export default Ember.Component.extend({

  isSelectFocused: false,
  placeholder: Ember.computed('trackableType', 'isSelectFocused', function() {
    if (this.get('isSelectFocused')) {
      return 'Start typing a '+this.get('trackableType');
    } else {
      return 'Add a '+this.get('trackableType');
    }
  }),

  optionCreateComponent: Ember.computed('trackableType', function() {
    return `select-field/${this.get('trackableType')}-create-option`;
  }),

  actions: {
    toggleSelectFocused() {
      this.toggleProperty('isSelectFocused');
    },
    onSelectAction(selectedTrackable) {
      this.get('onSelect')(selectedTrackable);
    }
  }
});
